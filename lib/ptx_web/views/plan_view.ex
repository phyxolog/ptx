defmodule PtxWeb.PlanView do
  use PtxWeb, :view

  alias PtxWeb.PlanView

  def render("list.json", %{list: list}) do
    list
  end

  def render("index.json", %{plans: %Scrivener.Page{} = plans}) do
    %{plans | entries: render_many(plans.entries, PlanView, "plan.json")}
  end

  def render("index.json", %{plans: plans}) do
    %{data: render_many(plans, PlanView, "plan.json")}
  end

  def render("show.json", %{plan: plan}) do
    %{data: render_one(plan, PlanView, "plan.json")}
  end

  def render("plan.json", %{plan: plan}) do
    plan
  end
end
