defmodule Ptx.Accounts do
  @moduledoc """
  The Accounts context.
  """
  import Ecto.Query, warn: false
  alias Ptx.{Repo, Messages}
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
    %{
      sent_count: Messages.get_sended_messages_count(user_id, params),
      read_count: Messages.get_readed_messages_count(user_id, params)
    }
  end
end
