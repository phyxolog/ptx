defmodule PtxWeb.PageController do
  use PtxWeb, :controller

  def pricing(conn, _params) do
    render conn, "pricing.html"
  end
end
