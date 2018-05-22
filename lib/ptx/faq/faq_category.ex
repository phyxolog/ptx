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
    has_many :faqs, Faq, foreign_key: :category_id
  end

  @field_list Enum.reduce(@locales, [:id], &([String.to_existing_atom("title_#{&1}") | &2]))

  def faqs_preload_query do
    from q in Faq,
      select: map(q, @field_list)
  end

  def preloaded, do: [faqs: faqs_preload_query()]

  @doc """
  List of Frequently Asked Questions.
  With pagination.
  """
  def list() do
    query = from fc in FaqCategory,
      preload: ^preloaded(),
      select: fc

    Ptx.Repo.all(query)
  end
end
