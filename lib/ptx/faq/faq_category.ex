defmodule Ptx.Faq.FaqCategory do
  use Ecto.Schema
  import Ecto.Query
  import I18n

  alias Ptx.Faq
  alias Ptx.Faq.FaqCategory

  @derive {Jason.Encoder, except: [:__meta__]}
  @locales Application.get_env(:ptx, PtxWeb.Gettext)[:locales]

  @translation_fields [
    %{name: :title, type: :string}
  ]

  schema "faq_categories" do
    i18n(@translation_fields)
    has_many :data, Faq, foreign_key: :category_id
  end

  def data_preload_query do
    field_list = Enum.reduce(@locales, [:id], &([:"title_#{&1}" | &2]))

    from q in Faq,
      select: map(q, ^field_list)
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
