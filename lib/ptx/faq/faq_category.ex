defmodule Ptx.Faq.FaqCategory do
  use Ecto.Schema
  import Ecto.Query
  require I18n

  alias Ptx.Faq
  alias Ptx.Faq.FaqCategory

  @derive {Jason.Encoder, except: [:__meta__]}

  @translation_fields [
    %{name: :title, type: :string}
  ]

  schema "faq_categories" do
    I18n.i18n(@translation_fields)
    has_many :data, Faq, foreign_key: :category_id
  end

  defmacro select_l(q) do
    quote do
      # TODO: Make automatically
      %{
        id: unquote(q).id,
        title_ru: unquote(q).title_ru,
        title_uk: unquote(q).title_uk,
        title_en: unquote(q).title_en
      }
    end
  end

  def data_preload_query do
    from q in Faq,
      select: select_l(q)
  end

  def preloaded, do: [data: data_preload_query()]

  @doc """
  List of Frequently Asked Questions.
  With pagination.
  """
  def list(params) do
    query = from fc in FaqCategory,
      preload: ^preloaded(),
      select: fc

    Ptx.Repo.paginate(query, params)
  end
end
