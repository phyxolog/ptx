defmodule Ptx.Pay do
  import PtxWeb.Gettext
  import Ecto.Query, warn: false
  alias Ptx.{Accounts, Repo}
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
        plan: info.plan,
        periodicity: info.periodicity,
        user_id: info.user_id
      })
    end)
  end
  defp obtain_transaction(params),
    do: Accounts.fetch_transaction(id: params["order_id"])

  @doc """
  Processing callback from LiqPay
  """
  def process_callback({:ok, params}) do
    params = %{params | "info" => Ptx.Helper.decode_term(params["info"])}
    {:ok, user} = Accounts.fetch_user(id: params["info"].user_id)

    obtain_transaction(params)
    |> process_transaction(params, user)
  end

  ## Unsubscribe old success transaction
  defp unsubscribe_old(user_id) do
    transaction = Transaction
    |> where([t], t.user_id == ^user_id)
    |> where([t], t.status == "success")
    |> Repo.one()

    if transaction != nil do
      ExLiqpay.cancel_subscription(transaction.order_id)
      Accounts.update_transaction(transaction, %{status: "wait_unsubscribe"})
    end

    :ok
  end

  ## Send ticket to user and our email
  defp send_ticket(user, transaction) do
    Task.start(ExLiqpay, :ticket, [user.id, transaction.id])
    Task.start(ExLiqpay, :ticket, [@ticket_email, transaction.id])
  end

  defp process_transaction({:ok, transaction}, %{"status" => "subscribed"}, user) do
    ## First off, send ticket to user email and our email
    send_ticket(user, transaction)

    unsubscribe_old(user.id)
    Accounts.update_user(user, %{plan: transaction.plan, periodicity: transaction.periodicity})
  end

  defp process_transaction({:ok, transaction}, %{"status" => "success", "end_date" => end_date} = params, user) do
    send_ticket(user, transaction)

    Accounts.create_ticket(%{data: params, transaction_id: transaction.id})

    transaction =
      Accounts.update_transaction(transaction, %{status: "success"})

    valid_until =
      Timex.from_unix(end_date, :millisecond)
      |> Timex.shift("#{transaction.periodicity}s": 1)
      |> Timex.to_naive_datetime()

    Accounts.update_user(user, %{frozen: false, valid_until: valid_until})
  end

  defp process_transaction({:ok, transaction}, %{"status" => "unsubscribed"} = params, user) do
    send_ticket(user, transaction)

    Accounts.create_ticket(%{data: params, transaction_id: transaction.id})

    if transaction.status != "wait_unsubscribe" do
      Accounts.update_user(user, %{
        frozen: true,
        valid_until: nil,
        plan: nil,
        periodicity: nil
      })
    end

    Accounts.update_transaction(transaction, %{status: "unsubscribed"})
  end

  ## Process all statuses except 'success', 'subscribed', 'unsubscribed'.
  defp process_transaction({:ok, transaction}, %{"status" => status} = params, _user) do
    Accounts.create_ticket(%{data: params, transaction_id: transaction.id})
    Accounts.update_transaction(transaction, %{status: status})
  end

  ## If transaction not found or `info` doesn't exists - ok.
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
