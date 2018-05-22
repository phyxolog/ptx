defmodule Ptx.Pages.Page do
  use Ecto.Schema
  import I18n

  @derive {Jason.Encoder, except: [:__meta__]}
  @primary_key {:id, :string, [autogenerate: false]}
  @translation_fields [
    %{name: :title, type: :string},
    %{name: :text, type: :string}
  ]

  schema "pages" do
    i18n(@translation_fields)
  end
end
