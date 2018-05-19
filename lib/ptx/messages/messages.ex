defmodule Ptx.Messages do
  @moduledoc """
  The Messages context.
  """

  import Ecto.Query, warn: false
  alias Ptx.{Repo, Accounts}

  ## Composition of contexts
  use Ptx.Messages.Context.Message
  use Ptx.Messages.Context.Thread
  use Ptx.Messages.Context.Read
  use Ptx.Messages.Context.Link

  ## Send message to frontend about needed refresh markers on Gmail.
  defp send_refresh_markers(message) do
    params = %{
      subject: message.subject,
      readed_by: get_message_recipient(message),
      when: message.first_readed_at,
      sent_on: message.inserted_at,
      recipients: message.recipients
    }

    PtxWeb.Endpoint.broadcast("room:#{message.sender_id}", "refresh_markers", params)
  end

  def trace(nil), do: {:error, :empty_id}
  def trace(id) do
    case get_message(id) do
      {:ok, message} ->
        create_read(%{recepient: get_message_recipient(message), message: message})

        {:ok, user} = Accounts.fetch_user(id: message.sender_id)

        read_message(message, fn
          {:first_time, message} ->
            send_refresh_markers(message)

            if user.notification_settings.email_readed do
              ## TODO: Send email notify of read emails
            end
          {:once_again, message} ->
            send_refresh_markers(message)

            if user.plan in ["trial", "pro"] &&
              user.notification_settings.once_again_readed_email do
              ## TODO: Send email notify of read emails
            end
        end)
      _ -> {:error, :not_found}
    end

    {:ok, id}
  end

  def list_messages_by_thread_ids(thread_ids, sender_id) do
    query = from m in Message,
      where: m.sender_id == ^sender_id,
      where: m.thread_id in ^thread_ids,
      limit: 1000,
      preload: [:reads],
      select_merge: %{
        readed: fragment("(not (exists(select true from messages where thread_id = ? and readed = false limit 1)))", m.thread_id)
      }

    Repo.all(query)
  end
end
