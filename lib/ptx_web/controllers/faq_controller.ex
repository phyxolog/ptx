defmodule PtxWeb.FaqController do
  use PtxWeb, :controller

  alias Ptx.Faq

  def index(conn, params) do
    render(conn, "index.json", faqs: Faq.list(params))
  end
end
