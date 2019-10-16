defmodule PtxWeb.FaqView do
  use PtxWeb, :view

  alias PtxWeb.FaqView

  def render("index.json", %{faqs: %Scrivener.Page{} = faqs}) do
    %{faqs | entries: render_many(faqs.entries, FaqView, "faq.json")}
  end

  def render("index.json", %{faqs: faqs}) do
    %{data: render_many(faqs, FaqView, "faq.json")}
  end

  def render("show.json", %{faq: faq}) do
    %{data: render_one(faq, FaqView, "faq.json")}
  end

  def render("faq.json", %{faq: faq}) do
    faq
  end
end
