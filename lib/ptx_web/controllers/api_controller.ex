defmodule PtxWeb.ApiController do
  use PtxWeb, :controller
  use Guardian.Phoenix.Controller

  alias Ptx.Accounts

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
    json conn, Ptx.format_canonical_zone_list(Tzdata.canonical_zone_list())
  end
end
