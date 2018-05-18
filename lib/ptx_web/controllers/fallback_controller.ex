defmodule PtxWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use PtxWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(PtxWeb.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(PtxWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, :not_auth}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(PtxWeb.ErrorView)
    |> render(:"401")
  end

  def call(conn, {:error, {:reason, :hacker}}) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{error: %{details: "You want break me? Please, do not do this!"}})
  end

  def call(conn, {:error, {:reason, reason}}) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{error: %{details: reason}})
  end

  def call(conn, {:error, reason}) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{error: reason})
  end

  def call(conn, {:ok, result}) do
    conn
    |> json(result)
  end

  def call(conn, nil) do
    send_resp(conn, 204, "")
  end
end
