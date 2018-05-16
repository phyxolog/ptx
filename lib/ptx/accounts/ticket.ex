defmodule Ptx.Accounts.Ticket do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ptx.Accounts.Transaction

  schema "tickets" do
    field :data, :map
    belongs_to :transaction, Transaction
    timestamps()
  end

  @doc false
  def changeset(ticket, attrs) do
    ticket
    |> cast(attrs, [:data, :transaction_id])
    |> validate_required([:data, :transaction_id])
  end
end
