defmodule PtxWeb.PagesView do
  use PtxWeb, :view
  alias PtxWeb.PagesView

  def render("show.json", %{page: page}) do
    render_one(page, PagesView, "page.json", as: :page)
  end

  def render("page.json", %{page: page}) do
    page
  end
end
