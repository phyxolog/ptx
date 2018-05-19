defmodule PtxWeb.FaqController do
  use PtxWeb, :controller

  alias Ptx.Faq
  alias Ptx.Faq.FaqCategory

  def list(conn, params) do
    render(conn, "list.json", list: FaqCategory.list(params))
  end

  def show(conn, %{"id" => id}) do
    render(conn, "show.json", faq: Faq.show(id))
  end
end
