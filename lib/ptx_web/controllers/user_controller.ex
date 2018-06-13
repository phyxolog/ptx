defmodule PtxWeb.UserController do
  use PtxWeb, :controller
  use Guardian.Phoenix.Controller

  alias Ptx.{Accounts, Messages}
  alias Ptx.Accounts.User

  action_fallback PtxWeb.FallbackController

  @allow_user_update_fields ~w(first_name last_name gender locale timezone notification_settings)

  def update(conn, %{"id" => unsafe_id} = params, %User{id: id}) when unsafe_id == id do
    Accounts.fetch_user(id: id)
    |> OK.bind(fn user ->
      params = Map.take(params, @allow_user_update_fields)
      with {:ok, %User{} = user} <- Accounts.update_user(user, params) do
        render(conn, "show.json", user: user)
      end
    end)
  end

  def delete(conn, %{"id" => unsafe_id}, %User{id: id} = user) when unsafe_id == id do
    Accounts.mark_user_as_deleted(user)
    json conn, %{status: :success}
  end

  def unsubscribe(conn, %{"user_id" => user_id}, %{id: id} = user) when user_id == id do
    Accounts.unsubscribe(user)
    json conn, %{status: :wait}
  end

  def statistic(_conn, %{"user_id" => user_id} = params, %{id: id}) when user_id == id do
    statistic = Accounts.get_statistic(user_id, params)
    {:ok, statistic}
  end

  def links_statistic(_conn, %{"user_id" => user_id} = params, %{id: id}) when user_id == id do
    messages = Messages.list_messages_with_links_by_sender(user_id, params)
    {:ok, messages}
  end

  def recipients(_conn, %{"user_id" => user_id}, %{id: id}) when user_id == id do
    recipients = Accounts.recipients(user_id)
    {:ok, recipients}
  end

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
