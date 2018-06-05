defmodule PtxWeb.UserView do
  use PtxWeb, :view
  alias PtxWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{user | timezone_offset: Ptx.get_timezone_offset_by_name(user.timezone)}
  end
end
