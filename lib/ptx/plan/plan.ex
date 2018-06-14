defmodule Ptx.Plan do
  use Ecto.Schema
  import Ecto.Query
  import I18n
  alias Ptx.Plan

  @derive {Jason.Encoder, except: [:__meta__]}

  @translation_fields [
    %{name: :title, type: :string},
    %{name: :text, type: :string}
  ]

  schema "plans" do
    i18n(@translation_fields)
    field :order, :integer
  end

  @doc """
  Gets a single faq.
  """
  def list() do
    Plan
    |> order_by([fc], fc.order)
    |> Ptx.Repo.all()
  end

  @doc """
  Gets a single faq.
  """
  def show(id) do
    Plan
    |> where(id: ^id)
    |> Ptx.Repo.one()
  end
end
