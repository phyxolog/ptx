defmodule PtxWeb.MessageView do
  use PtxWeb, :view
  alias PtxWeb.MessageView

  def render("index.json", %{messages: messages}) do
    render_many(messages, MessageView, "message.json")
  end

  def render("show.json", %{message: message}) do
    render_one(message, MessageView, "message.json")
  end

  def render("message.json", %{message: message}) do
    message
  end
end
