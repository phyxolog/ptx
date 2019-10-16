defmodule PtxWeb.TraceController do
  use PtxWeb, :controller

  alias Ptx.Messages

  def index(conn, params) do
    Messages.trace(params["id"])

    conn
    |> put_resp_header("cache-control", "private")
    |> put_resp_header("content-length", "0")
    |> send_resp(200, "")
  end
end
