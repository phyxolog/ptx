defmodule Ptx.MailSender do
  use Bamboo.Phoenix, view: Ptx.Mailer.EmailView
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
  # rescue
  #   error -> Logger.error("Error when email was send. #{inspect error}")
  end

  def send(method, user, opts \\ [])
  def send(method, user, opts) do
    Gettext.with_locale(PtxWeb.Gettext, user.locale, fn ->
      conformity_table = [
        welcome: gettext("Welcome!"),
        read_email: gettext("Your email has been read!"),
        link_opened: gettext("Your link has been clicked!"),
        change_plan: gettext("Your plan has been changed!"),
        new_plan: gettext("The plan is fixed for you!"),
        frozen: gettext("Your account has been frozen!"),
        outdated: gettext("Your account has been outdated!"),
        unsubscribed: gettext("You successfully unsubscribed!")
      ]

      if conformity_table[method] != nil do
        subject = conformity_table[method]
        deliver(user.id, subject, Atom.to_string(method) <> ".html", Keyword.put(opts, :user, user))
      else
        Logger.error("Not found handler for Ptx.MailSender.send/3.\nMethod: #{inspect method}")
      end
    end)
  end
end
