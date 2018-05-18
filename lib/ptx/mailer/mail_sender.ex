defmodule Ptx.MailSender do
  use Bamboo.Phoenix, view: Ptx.Mailer.View
  import Bamboo.Email
  import PtxWeb.Gettext, only: [gettext: 1]
  require Logger
  alias Ptx.Mailer

  @from_string Application.get_env(:ptx, :from_email_string)

  @doc """
  Constructor for base email. Create layout from `email.html`.
  """
  def base_email do
    new_email()
    |> from(gettext(@from_string))
    |> put_html_layout({Mailer.Layout, "email.html"})
  end

  ## Deliver mail. Async.
  defp deliver(to, subject, layout, assigns) do
    assigns = Keyword.put(assigns, :title, subject)

    base_email()
    |> to(to)
    |> subject(subject)
    |> render(layout, assigns)
    |> Mailer.deliver_later()
  end

  def send(_method, _user, _params \\ [])
  def send(:read_email, user, opts) do
    Gettext.with_locale(PtxWeb.Gettext, user.locale, fn ->
      subject = gettext("Your email has been read!")
      deliver(user.id, subject, "read_email.html", opts)
    end)
  end

  def send(:account_binding, user, opts) do
    Gettext.with_locale(PtxWeb.Gettext, user.locale, fn ->
      subject = gettext("Our congratulations!")
      deliver(user.id, subject, "account_binding.html", opts)
    end)
  end

  def send(:welcome, user, opts) do
    Gettext.with_locale(PtxWeb.Gettext, user.locale, fn ->
      subject = gettext("Welcome!")
      deliver(user.id, subject, "welcome.html", opts)
    end)
  end

  def send(method, _user, _params) do
    Logger.error("Not found handle for Ptx.MailSender.send/3.\nMethod: #{inspect method}")
  end
end
