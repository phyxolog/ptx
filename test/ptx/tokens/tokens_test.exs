defmodule Ptx.TokensTest do
  use Ptx.DataCase

  alias Ptx.Tokens

  describe "tokens" do
    alias Ptx.Tokens.Token

    @valid_attrs %{guardian_token_id: "7488a646-e31f-11e4-aace-600308960662"}
    @update_attrs %{guardian_token_id: "7488a646-e31f-11e4-aace-600308960668"}
    @invalid_attrs %{guardian_token_id: nil}

    def token_fixture(attrs \\ %{}) do
      {:ok, token} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Tokens.create_token()

      token
    end

    test "list_tokens/0 returns all tokens" do
      token = token_fixture()
      assert Tokens.list_tokens() == [token]
    end

    test "get_token!/1 returns the token with given id" do
      token = token_fixture()
      assert Tokens.get_token!(token.id) == token
    end

    test "create_token/1 with valid data creates a token" do
      assert {:ok, %Token{} = token} = Tokens.create_token(@valid_attrs)
      assert token.guardian_token_id == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tokens.create_token(@invalid_attrs)
    end

    test "update_token/2 with valid data updates the token" do
      token = token_fixture()
      assert {:ok, token} = Tokens.update_token(token, @update_attrs)
      assert %Token{} = token
      assert token.guardian_token_id == "7488a646-e31f-11e4-aace-600308960668"
    end

    test "update_token/2 with invalid data returns error changeset" do
      token = token_fixture()
      assert {:error, %Ecto.Changeset{}} = Tokens.update_token(token, @invalid_attrs)
      assert token == Tokens.get_token!(token.id)
    end

    test "delete_token/1 deletes the token" do
      token = token_fixture()
      assert {:ok, %Token{}} = Tokens.delete_token(token)
      assert_raise Ecto.NoResultsError, fn -> Tokens.get_token!(token.id) end
    end

    test "change_token/1 returns a token changeset" do
      token = token_fixture()
      assert %Ecto.Changeset{} = Tokens.change_token(token)
    end
  end
end
