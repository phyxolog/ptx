defmodule PtxWeb.UserControllerTest do
  use PtxWeb.ConnCase

  alias Ptx.Accounts
  alias Ptx.Accounts.User

  @create_attrs %{access_token: "some access_token", expires_at: 42, first_name: "some first_name", full_name: "some full_name", gender: "some gender", last_name: "some last_name", locale: "some locale", picture: "some picture", refresh_token: "some refresh_token"}
  @update_attrs %{access_token: "some updated access_token", expires_at: 43, first_name: "some updated first_name", full_name: "some updated full_name", gender: "some updated gender", last_name: "some updated last_name", locale: "some updated locale", picture: "some updated picture", refresh_token: "some updated refresh_token"}
  @invalid_attrs %{access_token: nil, expires_at: nil, first_name: nil, full_name: nil, gender: nil, last_name: nil, locale: nil, picture: nil, refresh_token: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get conn, user_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, user_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "access_token" => "some access_token",
        "expires_at" => 42,
        "first_name" => "some first_name",
        "full_name" => "some full_name",
        "gender" => "some gender",
        "last_name" => "some last_name",
        "locale" => "some locale",
        "picture" => "some picture",
        "refresh_token" => "some refresh_token"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put conn, user_path(conn, :update, user), user: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, user_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "access_token" => "some updated access_token",
        "expires_at" => 43,
        "first_name" => "some updated first_name",
        "full_name" => "some updated full_name",
        "gender" => "some updated gender",
        "last_name" => "some updated last_name",
        "locale" => "some updated locale",
        "picture" => "some updated picture",
        "refresh_token" => "some updated refresh_token"}
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete conn, user_path(conn, :delete, user)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, user_path(conn, :show, user)
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
