defmodule Ptx.Pay do
  import PtxWeb.Gettext
  import Ecto.Query, warn: false
  alias Ptx.{Accounts, Repo}
  alias Ptx.Accounts.Transaction
  require Logger

  @env Application.get_env(:ptx, :env)
  @url Application.get_env(:ptx, :url)
  @currency Application.get_env(:ptx, :currency)
  @prices Application.get_env(:ptx, :prices)
  @ticket_email Application.get_env(:ptx, :ticket_email)

  defp sandbox? when @env in [:dev, :test], do: "1"
  defp sandbox?, do: "0"

  @doc """
  Generate LiqPay pay-link with given params.
  """
  def generate_link(%{"plan" => plan, "periodicity" => periodicity, "locale" => locale}, user) do
    plan = String.to_existing_atom(plan)
    periodicity = String.to_existing_atom(periodicity)
    amount = @prices[plan][periodicity]

    generate_pay_link([
      locale: locale,
      amount: amount,
      periodicity: periodicity,
      currency: @currency,
      info: Ptx.Helper.encode_term(%{user_id: user.id, plan: plan, periodicity: periodicity}),
      description: Gettext.with_locale(locale, fn ->
        gettext("Payment of the «%{plan}» for %{email}", plan: String.capitalize(to_string(plan)), email: user.id)
      end)
    ])
  end
  def generate_link(_params, _user), do: {:error, :not_enough_params}

  ## Create transaction when callback status is subscribed.
  ## In other cases - get transaction from database.
  defp obtain_transaction(%{"status" => "subscribed", "order_id" => order_id, "amount" => amount} = params) do
    params
    |> Map.get("info")
    |> OK.required()
    |> OK.bind(fn info ->
      Accounts.delete_old_user_transactions(info.user_id)

      Accounts.create_transaction(%{
        id: order_id,
        amount: amount,
        status: "subscribed",
        plan: to_string(info.plan),
        periodicity: to_string(info.periodicity),
        user_id: info.user_id
      })
    end)
  end
  defp obtain_transaction(params),
    do: Accounts.fetch_transaction(id: params["order_id"])

  @doc """
  Processing callback from LiqPay
  """
  def process_callback({:ok, %{"info" => _info} = params}) do
    params = %{params | "info" => Ptx.Helper.decode_term(params["info"])}
    {:ok, user} = Accounts.fetch_user(id: params["info"].user_id)

    params
    |> obtain_transaction()
    |> process_transaction(params, user)
  end

  def process_callback({:ok, params}) do
    case obtain_transaction(params) do
      {:ok, transaction} ->
        {:ok, user} = Accounts.fetch_user(id: transaction.user_id)
        process_transaction({:ok, transaction}, params, user)
      _ -> Logger.error("Not found transaction with, params: #{inspect params}")
    end
  end

  ## Unsubscribe old success transaction
  def unsubscribe_old(user_id) do
    transaction = Transaction
    |> where([t], t.user_id == ^user_id)
    |> where([t], not t.status in ["wait_unsubscribe", "pending"])
    |> Repo.one()

    if transaction != nil do
      Accounts.update_transaction(transaction, %{status: "wait_unsubscribe"})
      ExLiqpay.cancel_subscription(transaction.id)
    end

    :ok
  end

  ## Send ticket to user and our email
  defp send_ticket(user, transaction) do
    Task.start(ExLiqpay, :ticket, [user.id, transaction.id])
    Task.start(ExLiqpay, :ticket, [@ticket_email, transaction.id])
  end

  defp process_transaction({:ok, transaction}, %{"status" => "subscribed"} = params, user) do
    ## First off, send ticket to user email and our email
    send_ticket(user, transaction)

    ticket = Accounts.create_ticket(%{data: params, transaction_id: transaction.id})

    unsubscribe_old(user.id)

    Logger.info("Status = subscribed, params: #{inspect params}, ticket: #{inspect ticket}")
  end

  defp process_transaction({:ok, transaction}, %{"status" => "success"} = params, user) do
    send_ticket(user, transaction)

    Accounts.create_ticket(%{data: params, transaction_id: transaction.id})

    {:ok, transaction} =
      Accounts.update_transaction(transaction, %{status: "success"})

    valid_until =
      Timex.now()
      |> Timex.shift("#{transaction.periodicity}s": 1)
      |> Timex.to_naive_datetime()

    user = Accounts.update_user(user, %{
      plan: transaction.plan,
      periodicity: transaction.periodicity,
      valid_until: valid_until,
      expiring_tomorrow: false,
      in_unsubscribe_process: false,
      frozen: false
    })

    Logger.info("Status = success, params: #{inspect params}, valid_until: #{inspect valid_until}, new user: #{inspect user}")
  end

  defp process_transaction({:ok, transaction}, %{"status" => "unsubscribed"} = params, user) do
    send_ticket(user, transaction)

    ticket = Accounts.create_ticket(%{data: params, transaction_id: transaction.id})

    if transaction.status != "wait_unsubscribe" do
      Accounts.update_user(user, %{
        expiring_tomorrow: false,
        in_unsubscribe_process: false,
        frozen: true,
        valid_until: nil,
        plan: nil,
        periodicity: nil
      })
    end

    transaction =
      Accounts.update_transaction(transaction, %{status: "unsubscribed"})

    Logger.info("Status = unsubscribed, params: #{inspect params}, ticket: #{inspect ticket}, transaction: #{inspect transaction}")
  end

  ## Process all statuses except 'success', 'subscribed', 'unsubscribed'.
  defp process_transaction({:ok, transaction}, %{"status" => status} = params, user) do
    if status in ["error", "failure"] do
      Ptx.MailNotifier.pay_error_notify(user)
    end

    ticket = Accounts.create_ticket(%{data: params, transaction_id: transaction.id})
    transaction = Accounts.update_transaction(transaction, %{status: status})

    Logger.info("Status = #{status}, params: #{inspect params}, ticket: #{inspect ticket}, transaction: #{inspect transaction}")
  end

  ## If transaction not found - log and return ok.
  defp process_transaction({:error, reason}, params, user) do
    Logger.error("Error in process_transaction. Reason: #{inspect reason}.\nParams: #{inspect params}\nUser: #{inspect user}")
    :ok
  end

  ## Generate LiqPay pay link
  defp generate_pay_link(opts) do
    subscribe_date_start = Timex.format!(Timex.now(), "%F %T", :strftime)

    ## Set availability for pay link
    ## (20 minutes)
    expired_date =
      Timex.now()
      |> Timex.add(Timex.Duration.from_minutes(20))
      |> Timex.to_unix()
      |> Kernel.*(1000)

    ExLiqpay.subscription(%{
      amount: opts[:amount],
      currency: opts[:currency],
      subscribe_date_start: subscribe_date_start,
      subscribe_periodicity: opts[:periodicity],
      expired_date: expired_date,
      language: opts[:locale],
      sandbox: sandbox?(),
      description: opts[:description],
      info: opts[:info],
      server_url: "#{@url}/api/liqpay/callback",
      result_url: "#{@url}/office"
    })
  end
end
