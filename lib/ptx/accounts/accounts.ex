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

  @doc """
  Activate user trial period (if available)
  """
  def activate_user_trial(user) do
    case user do
      %{plan: nil} -> :ok
      %{plan: "trial"} -> :ok
      %{plan: plan} -> unsubscribe(user)
    end

    update_user(user, %{
      plan: "trial",
      frozen: false,
      valid_until: nil
    })
      
    {:ok, :activate}
  end

  @doc """
  Unsubscribe.
  """
  def unsubscribe(user) do
    transaction = Transaction
    |> where([t], t.user_id == ^user.id)
    |> where([t], not t.status in ["unsubscribed", "wait_unsubscribe", "pending"])
    |> Repo.one()

    if !is_nil(transaction) do
      update_user(user, %{in_unsubscribe_process: true})
      ExLiqpay.cancel_subscription(transaction.id)
    end

    {:ok, :success}
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
      opens_percent: (if send_count == 0, do: 0, else: Float.round((100 / send_count) * read_count))
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

  @doc """
  Mark user as deleted, clear all user messages
  and unsubscribe user.
  """
  def mark_user_as_deleted(user) do
    update_user(user, %{deleted: true})
    Messages.delete_all_messages_by_user(user)
    unsubscribe(user)
  end
end
