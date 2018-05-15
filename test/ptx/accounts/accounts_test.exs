defmodule Ptx.AccountsTest do
  use Ptx.DataCase

  alias Ptx.Accounts

  describe "users" do
    alias Ptx.Accounts.User

    @valid_attrs %{access_token: "some access_token", expires_at: 42, first_name: "some first_name", full_name: "some full_name", gender: "some gender", last_name: "some last_name", locale: "some locale", picture: "some picture", refresh_token: "some refresh_token"}
    @update_attrs %{access_token: "some updated access_token", expires_at: 43, first_name: "some updated first_name", full_name: "some updated full_name", gender: "some updated gender", last_name: "some updated last_name", locale: "some updated locale", picture: "some updated picture", refresh_token: "some updated refresh_token"}
    @invalid_attrs %{access_token: nil, expires_at: nil, first_name: nil, full_name: nil, gender: nil, last_name: nil, locale: nil, picture: nil, refresh_token: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.access_token == "some access_token"
      assert user.expires_at == 42
      assert user.first_name == "some first_name"
      assert user.full_name == "some full_name"
      assert user.gender == "some gender"
      assert user.last_name == "some last_name"
      assert user.locale == "some locale"
      assert user.picture == "some picture"
      assert user.refresh_token == "some refresh_token"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.access_token == "some updated access_token"
      assert user.expires_at == 43
      assert user.first_name == "some updated first_name"
      assert user.full_name == "some updated full_name"
      assert user.gender == "some updated gender"
      assert user.last_name == "some updated last_name"
      assert user.locale == "some updated locale"
      assert user.picture == "some updated picture"
      assert user.refresh_token == "some updated refresh_token"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
