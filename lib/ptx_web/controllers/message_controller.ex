defmodule PtxWeb.MessageController do
  use PtxWeb, :controller
  use Guardian.Phoenix.Controller

  alias Ptx.{Messages, Accounts}
  alias Ptx.Messages.Message

  action_fallback PtxWeb.FallbackController

  defp get_user(user, _token) when not is_nil(user), do: user
  defp get_user(_user, token) when not token in [nil, ""], do: Accounts.get_user_by_token(token)
  defp get_user(_user, _token), do: nil

  def index(conn, %{"thread_ids" => thread_ids} = params, user) do
    case get_user(user, params["token"]) do
      nil ->
        conn
        |> put_resp_header("Access-Control-Allow-Origin", "*")
        |> json(%{messages: []})
      user ->
        thread_ids = Enum.take(thread_ids, 1000)
        messages = Messages.list_messages_by_thread_ids(thread_ids, user.id)

        conn
        |> put_resp_header("Access-Control-Allow-Origin", "*")
        |> json(%{messages: messages})
    end
  end

  def index(conn, _params, _user) do
    conn
    |> put_resp_header("Access-Control-Allow-Origin", "*")
    |> json(%{messages: []})
  end

  def create(conn, params, user) do
    case get_user(user, params["token"]) do
      nil -> {:error, :not_auth}
      user ->
        with {:ok, %Message{} = _message} <- Messages.create_message(params, user) do
          conn
          |> put_status(:created)
          |> json(%{status: :created})
        end
    end
  end
end
