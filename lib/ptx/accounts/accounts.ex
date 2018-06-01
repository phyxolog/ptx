defmodule Ptx.Accounts do
  @moduledoc """
  The Accounts context.
  """
  import Ecto.Query, warn: false
  alias Ptx.{Repo, Messages}
  alias Ptx.Messages.Message
  require OK

  ## Composition of contexts
  use Ptx.Accounts.Context.User
  use Ptx.Accounts.Context.Transaction
  use Ptx.Accounts.Context.Ticket

  def unsubscribe(user) do
    fetch_transaction(user_id: user.id)
    |> OK.bind(fn
      transaction ->
        ExLiqpay.cancel_subscription(transaction.id)
        {:ok, :success}
    end)
  end

  @doc """
  Get account statistic.
  """
  def get_statistic(user_id, params) do
    send_count = Messages.get_sended_messages_count(user_id, params)
    read_count = Messages.get_readed_messages_count(user_id, params)

    %{
      send_count: send_count,
      read_count: read_count,
      avg_time_sec: Messages.get_avg_open_time(user_id, params),
      opens_percent: (if send_count == 0, do: 0, else: Float.ceil((100 / send_count) * read_count))
    }
  end

  @doc """
  Gets a list of recipients by user id.
  """
  def recipients(user_id) do
    query = from m in Message,
      where: m.sender_id == ^user_id,
      group_by: fragment("recipient"),
      select: fragment("unnest(?) AS recipient", m.recipients_clear)

    Repo.all(query)
  end
end
