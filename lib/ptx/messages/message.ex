defmodule Ptx.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ptx.Messages.Thread
  alias Ptx.Accounts.User

  @primary_key {:id, :string, [autogenerate: false]}
  @derive {Jason.Encoder, except: [:__meta__, :sender]}
  @optional_fields ~w(subject first_readed_at recipients_clear readed)a
  @required_fields ~w(thread_id recipients sender_id)a

  schema "messages" do
    field :subject, :string, default: nil
    field :recipients, {:array, :string}, default: []
    field :recipients_clear, {:array, :string}, default: []
    field :readed, :boolean, default: false
    field :first_readed_at, :naive_datetime
    field :first_readed_at_string, :string, virtual: true, default: nil
    belongs_to :sender, User
    belongs_to :thread, Thread
    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:sender_id)
    |> foreign_key_constraint(:thread_id)
  end
end
