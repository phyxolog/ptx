defmodule PtxWeb.LinkController do
  use PtxWeb, :controller
  use Guardian.Phoenix.Controller

  alias Ptx.Messages

  action_fallback PtxWeb.FallbackController

  ## TODO: Check link owner (if user - allow)
  def show(conn, %{"id" => id}, _user) do
    case Messages.get_link(id) do
      {:ok, link} ->
        conn
        |> put_resp_header("Access-Control-Allow-Origin", "*")
        |> json(link)
      _ -> {:error, :not_found}
    end
  end
end
