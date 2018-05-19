defmodule Ptx.Faq do
  use Ecto.Schema
  import Ecto.Query
  import I18n

  alias Ptx.Faq
  alias Ptx.Faq.FaqCategory

  @derive {Jason.Encoder, except: [:__meta__, :category_id]}

  @translation_fields [
    %{name: :title, type: :string},
    %{name: :text, type: :string}
  ]

  schema "faqs" do
    i18n(@translation_fields)
    belongs_to :category, FaqCategory
  end

  @doc """
  Gets a single faq.
  """
  def show(id) do
    Faq
    |> where(id: ^id)
    |> Ptx.Repo.one()
  end
end
