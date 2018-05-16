defmodule PtxWeb.PayController do
  use PtxWeb, :controller
  use Guardian.Phoenix.Controller
  alias Ptx.Pay

  def index(conn, _params, nil) do
    json conn, %{status: :not_auth}
  end

  def index(conn, %{"plan" => "trial"}, _user) do
    json conn, %{status: :trial}
  end

  def index(conn, params, user) do
    case Pay.generate_link(params, user) do
      {:ok, link} -> redirect(conn, external: link)
      _ -> json conn, %{status: :liqpay_link_generate_error}
    end
  end
end
