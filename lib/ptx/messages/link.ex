defmodule Ptx.Messages.Link do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ptx.Messages.Message

  @primary_key {:id, :binary_id, [autogenerate: false]}
  @derive {Jason.Encoder, except: [:__meta__, :message]}
  @optional_fields ~w(clicks_count)a
  @required_fields ~w(id text url)a

  schema "message_links" do
    field :clicks_count, :integer, default: 0
    field :text, :string
    field :url, :string
    belongs_to :message, Message, type: :string
    timestamps()
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
  end
end
