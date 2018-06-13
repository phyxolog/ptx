defmodule Ptx.MailNotifier do
  @moduledoc """
  Module for sending notifies to users.
  """

  alias Ptx.{MailSender, Messages}
  require OK

  ## Full implemented
  def welcome_notify(user) do
    MailSender.send(:welcome, user)
  end

  @doc """
  Called when someone open user email.

      email_inserted_at = Timex.shift(Timex.now(), minutes: -20)
      email_first_read_at = Timex.shift(Timex.now(), minutes: -10)

      Ptx.MailNotifier.read_email_notify(user, [
        subject: "Subject",
        email: nil,
        sent_date: Timex.format!(email_inserted_at, gettext("%Y-%m-%d at %H:%M"), :strftime),
        read_date: Timex.format!(email_first_read_at, gettext("%Y-%m-%d at %H:%M"), :strftime),
        read_user: "progur12art@gmail.com",
        recipients: ["test@gmail.com"]
      ])
  """
  def read_email_notify(user, params) do
    if user.notification_settings.email_read do
      MailSender.send(:read_email, user, params)
    end
  end

  @doc """
  Called when user opened our link.
  """
  def open_link_notify(message, link, user) do
    MailSender.send(:link_opened, user, [
      recipient: Messages.get_message_recipient(message),
      subject: message.subject,
      link: link
    ])
  end

  ## Ptx.MailNotifier.change_plan_notify(user, "trial", "pro")
  def change_plan_notify(user, plan_before, plan_after) do
    if user.notification_settings.plan_changed do
      MailSender.send(:change_plan, user, plan_before: plan_before, plan_after: plan_after)
    end
  end

  ## Ptx.MailNotifier.new_plan_notify(user)
  def new_plan_notify(user) do
    MailSender.send(:new_plan, user)
  end

  ## Ptx.MailNotifier.frozen_notify(user)
  def frozen_notify(user) do
    MailSender.send(:frozen, user)
  end

  ## Ptx.MailNotifier.outdated_notify(user)
  def outdated_notify(user) do
    MailSender.send(:outdated, user)
  end

  ## Ptx.MailNotifier.unsubscribed_notify(user)
  def unsubscribed_notify(user) do
    MailSender.send(:unsubscribed, user)
  end
end
