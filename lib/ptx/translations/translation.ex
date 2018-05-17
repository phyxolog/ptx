defmodule Ptx.Translations.Translation do
  use Ecto.Schema

  @primary_key {:id, :string, [autogenerate: false]}
  @derive {Jason.Encoder, except: [:__meta__]}

  schema "translations" do
    field :data, :map
  end
end
