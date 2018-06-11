defmodule PtxWeb.ApiController do
  use PtxWeb, :controller
  use Guardian.Phoenix.Controller

  alias Ptx.Accounts

  action_fallback PtxWeb.FallbackController

  def timestamp(conn, _params, _user) do
    timestamp = DateTime.to_unix(DateTime.utc_now(), :milliseconds)
    json conn, %{timestamp: timestamp}
  end

  def identity(conn, %{"token" => token}, _user) do
    user = Accounts.get_user_by_token(token)
    identity(conn, %{}, user)
  end

  def identity(_conn, _params, nil) do
    {:error, :not_auth}
  end

  def identity(conn, _params, user) do
    case user do
      %{deleted: true} -> {:ok, %{deleted: true}}
      user -> render(conn, PtxWeb.UserView, "show.json", user: user)
    end
  end

  def timezones(conn, _params, _user) do
    json conn, Ptx.Helper.format_canonical_zone_list(Tzdata.canonical_zone_list())
  end
end
