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

  @doc """
  Call when user opened email.
  """
  def trace(nil), do: {:error, :empty_uuid}
  def trace(uuid) do
    case fetch_message(uuid: uuid) do
      {:ok, message} ->
        create_read(%{recepient: get_message_recipient(message), message_id: message.id})

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

    :ok
  end

  @doc false
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

  @doc """
  Filter query by given `start_date`.
  Date need be in a format: DD.MM.YYYY
  """
  def filter_by_start_date(query, nil), do: query
  def filter_by_start_date(query, start_date) do
    case Timex.parse(start_date, "{0D}.{0M}.{YYYY}") do
      {:ok, date} ->
        date = Timex.to_naive_datetime(date)

        from q in query,
          where: q.inserted_at >= ^date
      _ -> query
    end
  end

  @doc """
  Filter query by given `end_date`.
  Date need be in a format: DD.MM.YYYY
  """
  def filter_by_end_date(query, nil), do: query
  def filter_by_end_date(query, end_date) do
    case Timex.parse(end_date, "{0D}.{0M}.{YYYY}") do
      {:ok, date} ->
        date = Timex.to_naive_datetime(date)

        from q in query,
          where: q.inserted_at <= ^date
      _ -> query
    end
  end

  @doc """
  Get count of send emails.
  Include filters by date fields.
  """
  def get_sended_messages_count(user_id, params) do
    Message
    |> filter_by_start_date(params["start_date"])
    |> filter_by_end_date(params["end_date"])
    |> where(sender_id: ^user_id)
    |> Repo.aggregate(:count, :id)
  end

  @doc """
  Get count of readed emails.
  Include filters by date fields.
  """
  def get_readed_messages_count(user_id, params) do
    Message
    |> filter_by_start_date(params["start_date"])
    |> filter_by_end_date(params["end_date"])
    |> where(sender_id: ^user_id)
    |> where(readed: true)
    |> Repo.aggregate(:count, :id)
  end

  @doc false
  def list_messages_with_links_by_sender(sender_id, params) do
    Message
    |> filter_by_start_date(params["start_date"])
    |> filter_by_end_date(params["end_date"])
    |> where(sender_id: ^sender_id)
    |> order_by(desc: :inserted_at)
    |> preload([:links])
    |> Repo.all()
  end
end
