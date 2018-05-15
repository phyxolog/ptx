defmodule PtxWeb.SessionController do
  use PtxWeb, :controller

  def auth_error(conn, {type, reason}, _opts) do
    conn
    |> put_status(400)
    |> json(%{error: %{type: to_string(type), reaosn: to_string(reason)}})
  end
end
