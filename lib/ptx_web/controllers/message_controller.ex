defmodule PtxWeb.MessageController do
  use PtxWeb, :controller
  use Guardian.Phoenix.Controller

  alias Ptx.Messages
  alias Ptx.Messages.Message

  action_fallback PtxWeb.FallbackController

  def create(_conn, _params, nil), do: {:error, :not_auth}
  def create(conn, params, user) do
    with {:ok, %Message{} = _message} <- Messages.create_message(params, user) do
      conn
      |> put_status(:created)
      |> json(%{status: :created})
    end
  end
end
