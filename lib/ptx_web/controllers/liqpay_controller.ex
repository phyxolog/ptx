defmodule PtxWeb.LiqPayController do
  use PtxWeb, :controller

  def callback(conn, params) do
    ExLiqpay.callback(params)
    |> Ptx.Pay.process_callback()

    json conn, %{status: :success}
  end
end
