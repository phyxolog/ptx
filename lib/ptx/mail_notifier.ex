defmodule Ptx.MailNotifier do
  @moduledoc """
  Module for sending notifies to users.
  """

  alias Ptx.{MailSender, Messages}

  def welcome_nofity(user) do
    MailSender.send(:welcome, user)
  end

  def change_plan_notify(user, old_plan, new_plan) do
    if user.notification_settings.plan_changed do
      MailSender.send(:plan_changed, user, old_plan: old_plan, new_plan: new_plan)
    end
  end

  def new_plan_notify(user) do
    MailSender.send(:new_plan, user)
  end

  def frozen(user) do
    MailSender.send(:frozen, user)
  end

  def frozen_trial(user) do
    MailSender.send(:frozen_trial, user)
  end

  def unsubscribe(user) do
    MailSender.send(:unsubscribe, user)
  end

  @doc """
  Called when someone open user email.
  """
  def read_email_notify(user, params) do
    if user.notification_settings.email_readed do
      MailSender.send(:read_email, user, params)
    end
  end

  @doc """
  Called when user opened our link.
  """
  def open_link_notify(message_uuid, _link_id) do
    user = Messages.get_user_by_message_uuid(message_uuid)
    if user.notification_settings.link_opened do
      # TODO: Get parameters for send an email
      MailSender.send(:link_opened, user, [])
    end
  end
end
