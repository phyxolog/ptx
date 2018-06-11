defmodule PtxWeb.AuthController do
  @moduledoc """
  Auth controller responsible for handling Ueberauth responses
  """

  use PtxWeb, :controller
  use Guardian.Phoenix.Controller
  alias Ptx.Accounts

  plug Ueberauth

  def hook(conn, _params, _user) do
    json conn, %{}
  end

  @doc """
  Handle errors.
  """
  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params, _user) do
    conn
    |> put_view(PtxWeb.ErrorView)
    |> render("auth_failure.html")
  end

  @doc """
  Handler for requests from pricing page.
  """
  def callback(conn, %{"state" => state}, _user) do
    state = Jason.decode!(URI.decode(state))
    |> Enum.map(fn {key, value} -> {String.to_existing_atom(key), value} end)
    |> Enum.into(%{})

    conn
    |> assign(:timezone_offset, state[:timezone_offset])
    |> do_callback()
    |> processign(state)
  end

  ## TODO: Where we must redirect user without pay state?
  def callback(conn, _params, _user) do
    conn
    |> do_callback()
    |> redirect(to: "/office")
  end

  ## Process pay state
  defp processign(conn, %{plan: _plan} = state) do
    query_string = URI.encode_query(state)

    conn
    |> redirect(to: "/pay?#{query_string}")
  end

  defp processign(conn, _state) do
    conn
    |> put_status(422)
    |> put_view(PtxWeb.ErrorView)
    |> render("422.html")
  end

  ## Get user attributes from Google response
  ## then finding user in our database or create new,
  ## update token from G response and put to our response
  ## and revoke old user token.
  defp do_callback(%{assigns: %{ueberauth_auth: auth} = assigns} = conn) do
    user =
      auth
      |> Map.put(:timezone_offset, assigns[:timezone_offset])
      |> load_user_params()
      |> Accounts.find_or_create_user()
      |> update_token(auth)
      |> reestablish_user()

    conn
    |> revoke_current_token()
    |> put_token_cookie(user)
  end

  ## Revoke current user token.
  defp revoke_current_token(conn) do
    token = conn.req_cookies["token"]
    Ptx.Guardian.revoke(token)

    conn
    |> delete_resp_cookie("token")
    |> Ptx.Guardian.Plug.sign_out()
  end

  ## Get a name of timezone offset
  ## Need for registration
  defp get_name_of_timezone_offset(timezone_offset) do
    timezone_offset
    |> Ptx.to_i()
    |> abs()
    |> div(60)
    |> Timex.Timezone.name_of()
  end

  ## Get user attributes from auth data.
  defp load_user_params(%{credentials: credentials, extra: extra, info: info, timezone_offset: timezone_offset}) do
    %{
      id: info.email,
      first_name: info.first_name,
      last_name: info.last_name,
      picture: info.image,
      full_name: info.name,
      locale: extra.raw_info.user["locale"],
      gender: extra.raw_info.user["gender"],
      token_type: credentials.token_type,
      access_token: credentials.token,
      refresh_token: credentials.refresh_token,
      expires_at: credentials.expires_at,
      timezone: get_name_of_timezone_offset(timezone_offset),
      notification_settings: Map.from_struct(%Ptx.Accounts.NotificationSettings{})
    }
  end

  ## Generate JWT and put to cookies.
  defp put_token_cookie(conn, {:ok, user}) do
    resource = %{id: user.id}
    conn = Ptx.Guardian.Plug.sign_in(conn, resource)
    token = Ptx.Guardian.Plug.current_token(conn)
    put_resp_cookie(conn, "token", token, max_age: 24 * 60 * 60 * 365, http_only: false)
  end

  ## Update token in given user.
  defp update_token({:ok, user}, %Ueberauth.Auth{credentials: credentials}) do
    ## We must update refresh_token,
    ## when his not nil
    ## and not equals
    {:ok, user} =
      update_rt({:ok, user}, credentials.refresh_token)

    Accounts.update_user(user, %{
      token_type: credentials.token_type,
      access_token: credentials.token,
      expires_at: credentials.expires_at
    })
  end

  ## Reestablish user if need
  defp reestablish_user({:ok, user}) do
    Accounts.update_user(user, %{deleted: false})
  end

  ## Update refresh_token
  defp update_rt(user, nil), do: user
  defp update_rt({:ok, %{refresh_token: user_refresh_token} = user}, refresh_token) when user_refresh_token != refresh_token do
    Accounts.update_user(user, %{refresh_token: refresh_token})
  end
  defp update_rt(user, _), do: user
end
