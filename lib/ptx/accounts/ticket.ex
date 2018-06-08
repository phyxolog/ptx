defmodule Ptx.Accounts.Ticket do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ptx.Accounts.Transaction

  @fields ~w(data transaction)a

  schema "tickets" do
    field :data, :map
    belongs_to :transaction, Transaction
    timestamps()
  end

  @doc false
  def changeset(ticket, attrs) do
    ticket
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
