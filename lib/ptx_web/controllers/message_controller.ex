defmodule PtxWeb.MessageController do
  use PtxWeb, :controller
  use Guardian.Phoenix.Controller

  alias Ptx.{Messages, Accounts}
  alias Ptx.Messages.Message

  action_fallback PtxWeb.FallbackController

  defp list_messages(conn, params, user, list, method) do
    case get_user(user, params["token"]) do
      nil -> res_json(conn, %{messages: []})
      user ->
        list = Enum.take(list, 1000)
        messages = apply(Messages, method, [list, user.id])
        res_json(conn, %{messages: messages})
    end
  end

  def index(conn, %{"thread_ids" => thread_ids} = params, user) do
    list_messages(conn, params, user, thread_ids, :list_messages_by_thread_ids)
  end

  def index(conn, %{"message_ids" => message_ids} = params, user) do
    list_messages(conn, params, user, message_ids, :list_messages_by_message_ids)
  end

  # def index(conn, params, user) do
  #   res_json(conn, Messages.list_messages_by_sender_id(params, user.id))
  # end

  def index(conn, _params, _user), do:
    res_json(conn, %{messages: []})

  def create(conn, params, user) do
    case get_user(user, params["token"]) do
      nil -> {:error, :not_auth}
      user ->
        Messages.get_or_insert_thread(params["thread_id"])

        with {:ok, %Message{} = _message} <- Messages.create_message(params, user) do
          conn
          |> put_status(:created)
          |> res_json(%{status: :created})
        end
    end
  end

  ## PRIVATE METHODS

  defp get_user(user, _token) when not is_nil(user), do: user
  defp get_user(_user, token) when not token in [nil, ""], do: Accounts.get_user_by_token(token)
  defp get_user(_user, _token), do: nil

  defp res_json(conn, data) do
    conn
    |> put_resp_header("Access-Control-Allow-Origin", "*")
    |> json(data)
  end
end
