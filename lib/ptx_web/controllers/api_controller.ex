defmodule PtxWeb.ApiController do
  use PtxWeb, :controller
  use Guardian.Phoenix.Controller

  alias Ptx.{Accounts, Messages}

  def timestamp(conn, _params, _user) do
    timestamp = DateTime.to_unix(DateTime.utc_now(), :milliseconds)
    json conn, %{timestamp: timestamp}
  end

  def identity(conn, %{"token" => token}, _user) do
    user = Accounts.get_user_by_token(token)
    render(conn, PtxWeb.UserView, "show.json", user: user)
  end

  def identity(conn, _params, user) do
    render(conn, PtxWeb.UserView, "show.json", user: user)
  end

  def timezones(conn, _params, _user) do
    json conn, Ptx.Helper.format_canonical_zone_list(Tzdata.canonical_zone_list())
  end

  def unsubscribe(_conn, _params, nil), do: {:error, :not_auth}
  def unsubscribe(conn, %{"user_id" => user_id}, %{id: id} = user) when user_id == id do
    Accounts.unsubscribe(user)
    json conn, %{status: :wait}
  end
  def unsubscribe(_conn, _params, _user), do: {:error, :not_found}

  def statictic(_conn, _params, nil), do: {:error, :not_auth}
  def statictic(_conn, %{"user_id" => user_id} = params, %{id: id}) when user_id == id do
    Accounts.get_statistic(user_id, params)
  end
  def statictic(_conn, _params, _user), do: {:error, :not_found}

  def links_statictic(_conn, _params, nil), do: {:error, :not_auth}
  def links_statictic(_conn, %{"user_id" => user_id} = params, %{id: id}) when user_id == id do
    messages = Messages.list_messages_with_links_by_sender(user_id, params)
    {:ok, messages}
  end
  def links_statictic(_conn, _params, _user), do: {:error, :not_found}
end
