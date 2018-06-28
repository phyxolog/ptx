defmodule Ptx.Mailer.Gmailer do
  alias Ptx.Google.OAuth

  def send_me(body, subject, user) do
    Task.start(fn ->
      message = message(body, subject, user)
      headers = headers(user)

      HTTPoison.post("https://www.googleapis.com/upload/gmail/v1/users/me/messages/send", message, headers)
    end)
  end

  defp message(body, subject, user) do
    """
    To: #{user.id}
    From: #{user.id}
    Subject: =?utf-8?B?#{subject}?=
    Content-Type: text/html; charset="UTF-8"

    #{body}
    """
  end

  defp headers(user) do
    {:ok, token} = OAuth.get_user_token(user)
    [
      "Content-Type": "message/rfc822",
      "Authorization": "Bearer #{token}"
    ]
  end
end
