defmodule PtxWeb.AuthController do
  @moduledoc """
  Auth controller responsible for handling Ueberauth responses
  """

  use PtxWeb, :controller
  use Guardian.Phoenix.Controller
  alias Ptx.Accounts

  plug Ueberauth

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
    do_callback(conn)
    |> processign(Ptx.Helper.decode_term(state))
  end

  ## TODO: Where we must redirect user without pay state?
  def callback(conn, _params, _user) do
    do_callback(conn)
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
  defp do_callback(%{assigns: %{ueberauth_auth: auth}} = conn) do
    user =
      load_user_params(auth)
      |> Accounts.find_or_create_user()
      |> update_token(auth)

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

  ## Get user attributes from auth data.
  defp load_user_params(%Ueberauth.Auth{credentials: credentials, extra: extra, info: info}) do
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
    }
  end

  ## Generate JWT and put to cookies.
  defp put_token_cookie(conn, {:ok, user}) do
    resource = %{id: user.id}
    conn = Ptx.Guardian.Plug.sign_in(conn, resource)
    token = Ptx.Guardian.Plug.current_token(conn)
    put_resp_cookie(conn, "token", token, max_age: 24 * 60 * 60 * 365)
  end

  ## Update token in given user.
  defp update_token({:ok, user}, %Ueberauth.Auth{credentials: credentials}) do
    ## We must not updated refresh_token,
    ## because refresh_token is only provided
    ## on the first authorization from the user
    Accounts.update_user(user, %{
      token_type: credentials.token_type,
      access_token: credentials.token,
      expires_at: credentials.expires_at
    })
  end
end
