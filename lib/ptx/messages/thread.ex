defmodule Ptx.Messages.Thread do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, [autogenerate: false]}
  @derive {Jason.Encoder, except: [:__meta__]}

  schema "threads" do
    timestamps()
  end

  @doc false
  def changeset(thread, attrs) do
    thread
    |> cast(attrs, [])
    |> validate_required([])
  end
end
