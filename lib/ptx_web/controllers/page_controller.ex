defmodule PtxWeb.PageController do
  use PtxWeb, :controller
  use Guardian.Phoenix.Controller

  def pricing(conn, _params, user) do
    # IO.inspect user
    render conn, "pricing.html"
  end
end
