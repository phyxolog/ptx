defmodule PtxWeb.PageController do
  use PtxWeb, :controller
  use Guardian.Phoenix.Controller

  def pricing(conn, _params, user) do
    conn
    |> assign(:user, user)
    |> render("pricing.html")
  end

  def getting_started(conn, _params, _user) do
    render conn, "getting_started.html"
  end

  def office(conn, _params, _user) do
    conn
    |> put_layout(false)
    |> render("office.html")
  end
end
