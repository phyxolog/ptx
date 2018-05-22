defmodule PtxWeb.FaqController do
  use PtxWeb, :controller

  alias Ptx.Faq
  alias Ptx.Faq.FaqCategory

  def list(conn, _params) do
    render(conn, "index.json", faqs: FaqCategory.list())
  end

  def show(conn, %{"id" => id}) do
    render(conn, "show.json", faq: Faq.show(id))
  end
end
