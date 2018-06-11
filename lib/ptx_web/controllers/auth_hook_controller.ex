defmodule PtxWeb.AuthHookController do
  use PtxWeb, :controller

  def hook(conn, params) do
    state = Map.get(params, "state", nil)
    |> Jason.encode!()

    conn
    |> assign(:state, state)
    |> render("index.html")
  end
end
