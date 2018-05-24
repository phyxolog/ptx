defmodule PtxWeb.FaqController do
  use PtxWeb, :controller

  alias Ptx.Faq
  alias Ptx.Faq.FaqCategory
  require OK

  def list(conn, _params) do
    render(conn, "index.json", faqs: FaqCategory.list())
  end

  def show(conn, %{"id" => id}) do
    case OK.required(Faq.show(id)) do
      {:ok, faq} -> render(conn, "show.json", faq: faq)
      _ -> {:error, :not_found}
    end
  end
end
