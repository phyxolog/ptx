defmodule Ptx.Faq do
  use Ecto.Schema
  alias Ptx.Faq
  require I18n

  @derive {Jason.Encoder, except: [:__meta__]}

  @translation_fields [
    %{name: :title, type: :string},
    %{name: :text, type: :string}
  ]

  schema "faqs" do
    I18n.i18n(@translation_fields)
  end

  @doc """
  List of Frequently Asked Questions.
  With pagination.
  """
  def list(params) do
    Ptx.Repo.paginate(Faq, params)
  end
end
