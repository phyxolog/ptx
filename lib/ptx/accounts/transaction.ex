defmodule Ptx.Accounts.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ptx.Accounts.User

  @primary_key {:id, :string, [autogenerate: false]}
  @foreign_key_type :string
  @derive {Jason.Encoder, except: [:__meta__]}
  @optional_fields ~w(status period)a
  @required_fields ~w(id plan periodicity amount user_id)a

  @statuses ~w(pending sandbox subscribed success unsubscribed wait_unsubscribe error failure)
  @plans ~w(basic pro)
  @periodicities ~w(month year)

  schema "transactions" do
    field :plan, :string, default: nil
    field :periodicity, :string, default: nil
    field :amount, :decimal, default: 0
    field :status, :string, default: "pending"
    field :period, :integer, default: 0
    belongs_to :user, User, type: :string
    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
    |> validate_inclusion(:status, @statuses)
    |> validate_inclusion(:plan, @plans)
    |> validate_inclusion(:periodicity, @periodicities)
  end
end
