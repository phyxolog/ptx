defmodule PtxWeb.UserChannel do
  use Phoenix.Channel

  def join("room:" <> _email, _params, socket) do
    {:ok, socket}
  end
end
