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
  rescue
    error -> Logger.error("Error when email was send. #{inspect error}")
  end

  @conformity_table [
    welcome: gettext("Welcome!"),
    read_email: gettext("Your email has been read!"),
    open_link: gettext("Your link has been clicked!"),
    change_plan: gettext("Your plan has been changed!"),
    new_plan: gettext("For you fixed the plan!"),
    frozen: gettext("Your account has been frozen!"),
    frozen_trial: gettext("Your account has been frozen!"),
    outdated: gettext("Your account has been outdated!"),
    outdated_trial: gettext("Your account has been outdated!"),
    unsubscribed: gettext("You successfully unsubscribed!")
  ]

  def send(method, user, opts \\ [])
  def send(method, user, opts) do
    if @conformity_table[method] != nil do
      Gettext.with_locale(PtxWeb.Gettext, user.locale, fn ->
        subject = @conformity_table[method]
        deliver(user.id, subject, Atom.to_string(method) <> ".html", Keyword.put(opts, :user, user))
      end)
    else
      Logger.error("Not found handler for Ptx.MailSender.send/3.\nMethod: #{inspect method}")
    end
  end
end
