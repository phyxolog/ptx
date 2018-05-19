defmodule PtxWeb.MessageController do
  use PtxWeb, :controller
  use Guardian.Phoenix.Controller

  alias Ptx.Messages
  alias Ptx.Messages.Message

  action_fallback PtxWeb.FallbackController

  def index(_conn, _params, nil), do: {:error, :not_auth}
  def index(_conn, %{"thread_ids" => thread_ids}, user) do
    thread_ids = Enum.take(thread_ids, 1000)
    messages = Messages.list_messages_by_thread_ids(thread_ids, user.id)
    {:ok, %{messages: messages}}
  end
  def index(_conn, _params, _user), do: {:ok, %{messages: []}}

  def create(_conn, _params, nil), do: {:error, :not_auth}
  def create(conn, params, user) do
    with {:ok, %Message{} = _message} <- Messages.create_message(params, user) do
      conn
      |> put_status(:created)
      |> json(%{status: :created})
    end
  end
end
