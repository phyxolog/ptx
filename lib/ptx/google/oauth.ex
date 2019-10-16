defmodule Ptx.Google.OAuth do
  use HTTPoison.Base
  alias Ptx.Accounts

  @google_client_id Application.get_env(:ueberauth, Ueberauth.Strategy.Google.OAuth)[:client_id]
  @google_client_secret Application.get_env(:ueberauth, Ueberauth.Strategy.Google.OAuth)[:client_secret]

  @doc """
  Checks if an access token has expired.
  """
  @spec access_token_expired?(map) :: boolean
  def access_token_expired?(%{expires_at: expires_at}) do
    expires_at - :os.system_time(:seconds) < 100
  end

  @doc """
  Send request to Google with our refresh_token
  and return a new access_token.
  """
  def get_new_access_token(refresh_token) do
    post("https://www.googleapis.com/oauth2/v4/token", {:form, [
      refresh_token: refresh_token,
      client_id: @google_client_id,
      client_secret: @google_client_secret,
      grant_type: "refresh_token"
    ]})
    |> OK.bind(fn
      %{body: %{"access_token" => access_token, "expires_in" => expires_in, "token_type" => token_type}} ->
        {:ok, %{access_token: access_token, expires_in: expires_in, token_type: token_type}}
      _ ->
        {:error, :invalid_refresh_token}
    end)
  end

  ## Check token on valid (expired or not).
  ## And if isn't valid - sending request to Google
  ## And getting a new token by own refresh_token.
  def get_user_token(user) do
    case access_token_expired?(user) do
      true ->
        check_and_refresh_user_token(user)
      false ->
        {:ok, user.access_token}
    end
  end

  defp check_and_refresh_user_token(user) do
    url = "https://www.googleapis.com/oauth2/v3/tokeninfo?"
    params = %{access_token: user.access_token}

    url <> URI.encode_query(params)
    |> get()
    ## First off, transform expires_in to integer
    ## for easy comparing in guard
    |> OK.bind(fn
      %{body: %{"expires_in" => expires_in}} = response ->
        {:ok, %{response | body: %{response.body | "expires_in" => String.to_integer(expires_in)}}}
      response -> {:ok, response}
    end)
    |> OK.bind(fn
      %{body: %{"error" => _}} ->
        refresh_and_get_user_token(user)
      %{body: %{"error_description" => _}} ->
        refresh_and_get_user_token(user)
      ## If expires_in less then 100 seconds - get new access token
      %{body: %{"expires_in" => expires_in}} when expires_in < 100 ->
        refresh_and_get_user_token(user)
      _ ->
        {:ok, user.access_token}
    end)
  end

  defp refresh_and_get_user_token(user) do
    case Accounts.refresh_access_token(user) do
      {:ok, user} ->
        {:ok, user.access_token}
      {:error, reason} ->
        {:error, reason}
    end
  end

  def process_response_body(body) do
    Jason.decode!(body)
  end
end
