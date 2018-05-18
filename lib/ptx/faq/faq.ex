defmodule Ptx.Faq do
  use Ecto.Schema
  require I18n

  alias Ptx.Repo

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
    Ptx.Faq
    |> Repo.paginate(params)
  end
end
