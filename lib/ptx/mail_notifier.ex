defmodule Ptx.MailNotifier do
  @moduledoc """
  Module for sending notifies to users.
  """

  alias Ptx.MailSender

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
  def open_link_notify(_email_id, _link_id) do
    # TODO
    # if user.notification_settings.link_opened do
    # end
    MailSender.send(:link_opened, nil, [])
  end

  def change_password_notify(user) do
    if user.notification_settings.change_pw do
      MailSender.send(:password_changed, user)
    end
  end

  def change_plan_notify(user, old_plan, new_plan) do
    if user.notification_settings.change_plan do
      MailSender.send(:plan_changed, user, old_plan: old_plan, new_plan: new_plan)
    end
  end

  def new_plan_notify(user, new_plan) do
    MailSender.send(:new_plan, user, new_plan: new_plan)
  end

  def account_binding_nofity(user, params) do
    MailSender.send(:account_binding, user, params)
  end

  def forgot_login_notify(user, params) do
    MailSender.send(:forgot_login, user, params)
  end

  def forgot_password_notify(user, params) do
    MailSender.send(:forgot_password, user, params)
  end

  def welcome_nofity(user, params) do
    MailSender.send(:welcome, user, params)
  end
end
