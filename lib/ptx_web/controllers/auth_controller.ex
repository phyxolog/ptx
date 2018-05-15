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
  Handler for requests from pricing page
  """
  def callback(conn, %{"state" => "pay_" <> _plan}, _user) do
    conn = do_callback(conn)

    ## TODO: Generate link for pay and redirect

    conn
    |> redirect(external: "https://liqpay.ua")
  end

  def callback(conn, _params, _user) do
    do_callback(conn)
    |> redirect(to: "/")
  end

  defp do_callback(%{assigns: %{ueberauth_auth: auth}} = conn) do
    user =
      load_user_params(auth)
      |> Accounts.find_or_create_user()
      |> update_token(auth)

    conn
    |> put_token_cookie(user)
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
    {:ok, token, _claims} = Ptx.Guardian.encode_and_sign(resource)

    conn
    |> put_resp_cookie("guardian_default_token", token, max_age: 24 * 60 * 60 * 365)
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
