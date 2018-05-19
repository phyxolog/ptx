defmodule Ptx.Pages do
  @moduledoc """
  The Pages context.
  """

  import Ecto.Query, warn: false
  require OK
  alias Ptx.Repo
  alias Ptx.Pages.Page

  @doc """
  Gets a single page.
  """
  def get_page(id) do
    Page
    |> where(id: ^id)
    |> Repo.one()
    |> OK.required(:not_found)
  end
end
