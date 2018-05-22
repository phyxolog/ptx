defmodule PtxWeb.PagesController do
  use PtxWeb, :controller

  def index(conn, %{"id" => id}) do
    case Ptx.Pages.get_page(id) do
      {:ok, page} -> render(conn, "show.json", page: page)
      _ -> {:error, :not_found}
    end
  end
end
