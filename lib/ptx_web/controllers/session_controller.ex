defmodule PtxWeb.SessionController do
  use PtxWeb, :controller

  def auth_error(conn, _params, _opts) do
    conn
    |> delete_resp_cookie("guardian_default_token")
    |> redirect(to: conn.request_path)
  end
end
