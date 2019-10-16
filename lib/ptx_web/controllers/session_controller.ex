defmodule PtxWeb.SessionController do
  use PtxWeb, :controller

  def auth_error(conn, _params, _opts) do
    if String.starts_with?(conn.request_path, "/api/") do
      conn
      |> put_status(401)
      |> render(PtxWeb.ErrorView, :"401.json")
    else
      conn
      |> delete_resp_cookie("token")
      |> Ptx.Guardian.Plug.sign_out()
      |> redirect(to: conn.request_path)
    end
  end
end
