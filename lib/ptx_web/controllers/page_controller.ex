defmodule PtxWeb.PageController do
  use PtxWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
