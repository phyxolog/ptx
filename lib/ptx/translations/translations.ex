defmodule Ptx.Translations do
  @moduledoc """
  The Translations context.
  """

  import Ecto.Query, warn: false
  require OK

  alias Ptx.Repo
  alias Ptx.Translations.Translation

  @doc """
  Get translation by given code (id, example: "ru", "en")
  and chunk name (it's key in json object).
  """
  def get_translation(id, chunk_name) when not nil in [id, chunk_name] do
    Translation
    |> where(id: ^id)
    |> select([t], fragment("?->?", t.data, ^chunk_name))
    |> Repo.one()
    |> OK.required(:not_found)
  end
  def get_translation(_, _), do: {:error, :not_found}
end
