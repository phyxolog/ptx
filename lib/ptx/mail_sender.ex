defmodule Ptx.MailSender do
  def send(_method, _user, _params \\ []) do
    IO.inspect "Send mail"
  end
end
