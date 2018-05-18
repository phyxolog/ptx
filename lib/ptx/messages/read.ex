defmodule Ptx.Messages.Read do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ptx.Messages.Message

  @derive {Jason.Encoder, except: [:__meta__]}
  @optional_fields ~w(recepient)a
  @required_fields ~w(email_id)a

  schema "email_read_list" do
    field :recepient, :string, default: nil
    belongs_to :message, Message, type: :string
    timestamps(updated_at: false)
  end

  @doc false
  def changeset(read, attrs) do
    read
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> cast_assoc(:email)
    |> foreign_key_constraint(:email_id)
    |> validate_required(@required_fields)
  end
end
