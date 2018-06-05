defmodule Ptx.Messages do
  @moduledoc """
  The Messages context.
  """

  import Ecto.Query, warn: false
  import PtxWeb.Gettext
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

  ## Send email notify of read emails
  defp send_email_when_read(user, message) do
    Ptx.MailNotifier.read_email_notify(user, [
      subject: message.subject,
      sent_date: Timex.format!(message.inserted_at, gettext("%Y-%m-%d at %H:%M"), :strftime),
      read_date: Timex.format!(message.first_readed_at, gettext("%Y-%m-%d at %H:%M"), :strftime),
      read_user: get_message_recipient(message),
      recipients: message.recipients
    ])
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

            if user.notification_settings.email_read do
              send_email_when_read(user, message)
            end
          {:once_again, message} ->
            send_refresh_markers(message)

            if user.plan in ["trial", "pro"] &&
              user.notification_settings.email_opened_again do
              send_email_when_read(user, message)
            end
        end)
      _ -> {:error, :not_found}
    end

    :ok
  end

  defp preload_reads do
    order_by(Read, asc: :inserted_at)
  end

  @doc false
  def list_messages_by_thread_ids(thread_ids, sender_id) do
    query = from m in Message,
      where: m.sender_id == ^sender_id,
      where: m.thread_id in ^thread_ids,
      limit: 1000,
      select_merge: %{
        readed: fragment("(not (exists(select true from messages where thread_id = ? and readed = false limit 1)))", m.thread_id)
      }

    Repo.all(query)
    |> Repo.preload([reads: preload_reads()])
  end

  ## Parse date
  defp parse_date(date) do
    case Timex.parse(date, "{0D}.{0M}.{YYYY}") do
      {:ok, date} ->
        {:ok, Timex.to_naive_datetime(date)}
      _ -> {:error, :invalid_date}
    end
  end

  @doc """
  Filter query by given `start_date`.
  Date need be in a format: DD.MM.YYYY
  """
  def filter_by_start_date(query, nil), do: query
  def filter_by_start_date(query, start_date) do
    case parse_date(start_date) do
      {:ok, date} -> where(query, [q], q.inserted_at >= ^date)
      _ -> query
    end
  end

  @doc """
  Filter query by given `end_date`.
  Date need be in a format: DD.MM.YYYY
  """
  def filter_by_end_date(query, nil), do: query
  def filter_by_end_date(query, end_date) do
    case parse_date(end_date) do
      {:ok, date} -> where(query, [q], q.inserted_at <= ^date)
      _ -> query
    end
  end

  @doc """
  Filter by recipients list.
  """
  def filter_by_recipients(query, recipients) when not is_list(recipients), do: query
  def filter_by_recipients(query, recipients) do
    from q in query,
      where: fragment("? && ?", ^recipients, q.recipients_clear)
  end

  @doc """
  Gets a average of time email opening.
  """
  def get_avg_open_time(user_id, params) do
    Message
    |> filter_by_start_date(params["start_date"])
    |> filter_by_end_date(params["end_date"])
    |> filter_by_recipients(params["recipients"])
    |> where(sender_id: ^user_id)
    |> where([m], not is_nil(m.first_readed_at))
    |> select([m], fragment("ceil(EXTRACT(EPOCH FROM avg((? - ?)::interval)))", m.first_readed_at, m.inserted_at))
    |> Repo.one()
  end

  # /*SELECT ceil(EXTRACT(EPOCH FROM avg((first_readed_at - inserted_at)::interval)))
  # FROM messages AS m
  # WHERE first_readed_at IS NOT NULL;*/

  # /*SELECT *
  # FROM date_trunc('day', current_date);*/

  # --select date_trunc('day', current_date) + interval '1 day' - interval '1 second'

  # --SELECT * FROM CURRENT_TIME

  # SELECT key::time,
  # (key + interval '59 minutes 59 seconds')::time AS before,
  # (SELECT ceil(EXTRACT(EPOCH FROM avg((first_readed_at - inserted_at)::interval))) FROM messages WHERE first_readed_at::time BETWEEN key::time AND (key + interval '59 minutes')::time) AS value
  # FROM generate_series(current_date, current_date + interval '1 day' - interval '1 second', '1 hour'::interval) AS key

  # --(SELECT ceil(EXTRACT(EPOCH from MAX(first_readed_at - inserted_at)) / 60) FROM messages)

  # --SELECT key::date AS key,
  # --(SELECT ceil(EXTRACT(EPOCH from avg(first_readed_at - inserted_at)) / 60) FROM messages WHERE first_readed_at - interval '1 day' + interval '1 second' BETWEEN key AND key + interval '1 day' - interval '1 second') AS value
  # --FROM generate_series('2018-05-20', '2018-06-01', '1 day'::interval) AS key

  @doc """
  Gets a list of time (00:00 - 23:59) and count of opened email.
  """
  def time_and_count(user_id, params) do
    subq =
      Message
      |> where(sender_id: ^user_id)
      |> where([m], not is_nil(m.first_readed_at))
      |> filter_by_start_date(params["start_date"])
      |> filter_by_end_date(params["end_date"])
      |> filter_by_recipients(params["recipients"])

    query = from m in subquery(subq),
      right_join: time in fragment("SELECT generate_series(current_date, current_date + interval '1 day' - interval '1 second', '1 hour'::interval) AS key"),
      on: fragment("?::time BETWEEN ?::time AND (? + interval '59 minutes')::time", m.first_readed_at, time.key, time.key),
      group_by: time.key,
      order_by: time.key,
      select: %{
        key: fragment("?::time::text", time.key),
        value: count(m.id)
      }

    Repo.all(query)
    |> Enum.map(fn %{key: str} = map -> %{map | key: String.slice(str, 0, 5)} end)
  end

  defp param_or_min_date(params, user_id, field) do
    case parse_date(Map.get(params, field)) do
      {:ok, date} -> date
      _ ->
        Message
        |> where(sender_id: ^user_id)
        |> select([m], min(m.inserted_at))
        |> Repo.one()
    end
    |> NaiveDateTime.to_date()
    |> to_string()
  end

  defp param_or_max_date(params, user_id, field) do
    case parse_date(Map.get(params, field)) do
      {:ok, date} -> date
      _ ->
        Message
        |> where(sender_id: ^user_id)
        |> select([m], max(m.inserted_at))
        |> Repo.one()
    end
    |> NaiveDateTime.to_date()
    |> to_string()
  end

  def date_and_count(user_id, params) do
    subq =
      Message
      |> where(sender_id: ^user_id)
      |> where([m], not is_nil(m.first_readed_at))
      |> filter_by_start_date(params["start_date"])
      |> filter_by_end_date(params["end_date"])
      |> filter_by_recipients(params["recipients"])

    start_date = param_or_min_date(params, user_id, "start_date")
    end_date = param_or_max_date(params, user_id, "end_date")

    query = from m in subquery(subq),
      right_join: time in fragment("SELECT generate_series(?::text::timestamp without time zone, ?::text::timestamp without time zone, '1 day'::interval) AS key", ^start_date, ^end_date),
      on: fragment("? - interval '1 day' + interval '1 second' BETWEEN ? AND ? + interval '1 day' - interval '1 second'", m.first_readed_at, time.key, time.key),
      group_by: time.key,
      order_by: time.key,
      select: %{
        key: fragment("?::text", time.key),
        value: count(m.id)
      }

    Repo.all(query)
  end

  @doc """
  Get count of send emails.
  Include filters by date fields.
  """
  def get_sended_messages_count(user_id, params) do
    Message
    |> filter_by_start_date(params["start_date"])
    |> filter_by_end_date(params["end_date"])
    |> filter_by_recipients(params)
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
    |> filter_by_recipients(params)
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

  @doc """
  Gets a single user by email id.
  """
  def get_user_by_message_uuid(uuid) do
    alias Ptx.Accounts.User

    query = from m in Message,
      join: user in assoc(m, :sender),
      where: m.uuid == ^uuid,
      select: user

    Repo.one(query)
    |> Repo.preload(User.preloaded())
  end
end
