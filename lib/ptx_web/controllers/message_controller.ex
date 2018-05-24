defmodule PtxWeb.MessageController do
  use PtxWeb, :controller
  use Guardian.Phoenix.Controller

  alias Ptx.{Messages, Accounts}
  alias Ptx.Messages.Message

  action_fallback PtxWeb.FallbackController

  def index(conn, %{"token" => token} = params, _user) do
    index(conn, params, Accounts.get_user_by_token(token))
  end

  def index(_conn, _params, nil), do: {:error, :not_auth}
  def index(conn, %{"thread_ids" => thread_ids}, user) do
    thread_ids = Enum.take(thread_ids, 1000)
    messages = Messages.list_messages_by_thread_ids(thread_ids, user.id)

    conn
    |> put_resp_header("Access-Control-Allow-Origin", "*")
    |> json(%{messages: messages})
  end

  def index(conn, _params, _user) do
    conn
    |> put_resp_header("Access-Control-Allow-Origin", "*")
    |> json(%{messages: []})
  end

  def create(_conn, _params, nil), do: {:error, :not_auth}
  def create(conn, params, user) do
    with {:ok, %Message{} = _message} <- Messages.create_message(params, user) do
      conn
      |> put_status(:created)
      |> json(%{status: :created})
    end
  end
end
