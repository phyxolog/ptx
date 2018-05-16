defmodule Ptx.Pay do
  import PtxWeb.Gettext

  @env Application.get_env(:ptx, :env)
  @url Application.get_env(:ptx, :url)
  @currency Application.get_env(:ptx, :currency)
  @prices Application.get_env(:ptx, :prices)

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

  @doc """
  Processing callback from LiqPay
  """
  def process_callback({:ok, params}) do
    params = %{params | "info" => Ptx.Helper.decode_term(params.info)}
    IO.inspect params
  end

  ## Generate LiqPay pay link
  defp generate_pay_link(opts) do
    subscribe_date_start =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)
      |> NaiveDateTime.to_string()

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
