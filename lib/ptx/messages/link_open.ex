defmodule Ptx.Messages.LinkOpen do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ptx.Messages.Link

  @derive {Jason.Encoder, except: [:__meta__, :id, :link, :link_id]}
  @optional_fields ~w()a
  @required_fields ~w(link_id)a

  schema "link_opens" do
    belongs_to :link, Link, type: :binary_id
    timestamps(updated_at: false)
  end

  @doc false
  def changeset(link_open, attrs) do
    link_open
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
  end
end
