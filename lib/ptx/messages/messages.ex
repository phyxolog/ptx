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

  def trace(nil), do: {:error, :empty_id}
  def trace(id) do
    case get_message(id) do
      {:ok, message} ->
        create_read(%{recepient: get_message_recipient(message), message: message})

        {:ok, _user} = Accounts.fetch_user(id: message.sender_id)

        read_message(message, fn
          {:first_time, _message} ->
            ## TODO: Send broadcast to message.sender_id (socket)
            ## TODO: Send email notify of read emails
            ## If user.notification_settings.email_readed
            nil
          {:once_again, _message} ->
            ## Only if pro or trial account
            ## And if user.notification_settings.once_again_readed_email
            ## TODO: Send email notify of read emails
            nil
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
