defmodule PtxWeb.UserController do
  use PtxWeb, :controller
  use Guardian.Phoenix.Controller

  alias Ptx.Accounts
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
end
