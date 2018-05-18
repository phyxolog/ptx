defmodule Ptx.Messages.Thread do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ptx.Messages.Message

  @primary_key {:id, :string, [autogenerate: false]}
  @derive {Jason.Encoder, except: [:__meta__]}

  schema "threads" do
    field :readed, :boolean, virtual: true, default: false
    has_many :messages, Message
    timestamps()
  end

  @doc false
  def changeset(thread, attrs) do
    thread
    |> cast(attrs, [:id])
    |> unique_constraint(:id, name: :threads_pkey)
    |> validate_required([:id])
  end
end
