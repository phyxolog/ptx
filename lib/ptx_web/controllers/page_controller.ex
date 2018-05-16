defmodule PtxWeb.PageController do
  use PtxWeb, :controller
  use Guardian.Phoenix.Controller

  def pricing(conn, _params, _user) do
    render conn, "pricing.html"
  end
end
