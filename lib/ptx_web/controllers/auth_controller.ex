defmodule PtxWeb.AuthController do
  @moduledoc """
  Auth controller responsible for handling Ueberauth responses
  """

  use PtxWeb, :controller

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_view(PtxWeb.ErrorView)
    |> render("auth_failure.html")
  end

  @doc """
  Handler for requests from pricing page
  """
  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, %{"state" => "pay_" <> plan}) do
    IO.inspect auth
    json conn, %{status: :success, plan: plan}
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    IO.inspect auth
    json conn, %{status: :success}
  end
end
