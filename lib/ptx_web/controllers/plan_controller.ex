defmodule PtxWeb.PlanController do
  use PtxWeb, :controller

  alias Ptx.Plan

  def list(conn, _params) do
    render(conn, "list.json", list: Plan.list())
  end

  def show(conn, %{"id" => id}) do
    render(conn, "show.json", plan: Plan.show(id))
  end
end
