defmodule PtxWeb.TranslationController do
  @moduledoc """
  Controller for work with translations.
  """

  use PtxWeb, :controller
  alias Ptx.Translations
  require OK

  action_fallback PtxWeb.FallbackController

  def index(_conn, %{"locale" => locale, "chunk_name" => chunk_name} = _params) do
    Translations.get_translation(locale, chunk_name)
  end
  def index(_, _), do: {:error, :not_found}
end
