defmodule PtxWeb.PayController do
  use PtxWeb, :controller
  use Guardian.Phoenix.Controller
  alias Ptx.{Pay, Accounts}

  def index(conn, _params, nil) do
    conn
    |> put_view(PtxWeb.ErrorView)
    |> render("auth_failure.html")
  end

  def index(conn, %{"plan" => "trial"}, user) do
    case Accounts.activate_user_trial(user) do
      {:ok, :activated} ->
        redirect(conn, to: "/office/details")
      _ ->
        conn
        |> put_view(PtxWeb.ErrorView)
        |> render("trial_unavailable.html")
    end
  end

  def index(conn, params, user) do
    case Pay.generate_link(params, user) do
      {:ok, link} ->
        redirect(conn, external: link)
      _ ->
        conn
        |> put_view(PtxWeb.ErrorView)
        |> render("liqpay_link_generate_error.html")
    end
  end
end
