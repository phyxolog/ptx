defmodule PtxWeb.UserController do
  use PtxWeb, :controller
  use Guardian.Phoenix.Controller

  alias Ptx.{Accounts, Messages}
  alias Ptx.Accounts.User

  action_fallback PtxWeb.FallbackController

  @allow_user_update_fields ~w(first_name last_name gender locale timezone notification_settings)

  def update(_conn, _params, nil), do: {:error, :not_auth}
  def update(conn, %{"id" => unsafe_id} = params, %User{id: id}) when unsafe_id == id do
    Accounts.fetch_user(id: id)
    |> OK.bind(fn user ->
      params = Map.take(params, @allow_user_update_fields)
      with {:ok, %User{} = user} <- Accounts.update_user(user, params) do
        render(conn, "show.json", user: user)
      end
    end)
  end
  def update(_conn, _params, _user), do: {:error, :not_found}

  def unsubscribe(conn, %{"user_id" => user_id}, %{id: id} = user) when user_id == id do
    Accounts.unsubscribe(user)
    json conn, %{status: :wait}
  end
  def unsubscribe(_conn, _params, _user), do: {:error, :not_found}

  def statistic(_conn, %{"user_id" => user_id} = params, %{id: id}) when user_id == id do
    statistic = Accounts.get_statistic(user_id, params)
    {:ok, statistic}
  end
  def statistic(_conn, _params, _user), do: {:error, :not_found}

  def links_statistic(_conn, %{"user_id" => user_id} = params, %{id: id}) when user_id == id do
    messages = Messages.list_messages_with_links_by_sender(user_id, params)
    {:ok, messages}
  end
  def links_statistic(_conn, _params, _user), do: {:error, :not_found}

  def recipients(_conn, %{"user_id" => user_id}, %{id: id}) when user_id == id do
    recipients = Accounts.recipients(user_id)
    {:ok, recipients}
  end
  def recipients(_conn, _params, _user), do: {:error, :not_found}

  def graph(_conn, %{"type" => type} = params, user) do
    graph = case type do
      "time_and_count" ->
        Messages.time_and_count(user, params)
      "date_and_count" ->
        Messages.date_and_count(user, params)
      "time_and_open" ->
        Messages.time_and_open(user, params)
      "date_and_open" ->
        Messages.date_and_open(user, params)
    end

    {:ok, graph}
  end
end
