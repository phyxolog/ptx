defmodule Ptx.Accounts do
  @moduledoc """
  The Accounts context.
  """
  import Ecto.Query, warn: false
  alias Ptx.Repo

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
end
