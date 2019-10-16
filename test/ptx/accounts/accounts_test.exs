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

  describe "transactions" do
    alias Ptx.Accounts.Transaction

    @valid_attrs %{amount: "120.5", period: 42, periodicity: "some periodicity", plan: "some plan", receipt: %{}, status: "some status"}
    @update_attrs %{amount: "456.7", period: 43, periodicity: "some updated periodicity", plan: "some updated plan", receipt: %{}, status: "some updated status"}
    @invalid_attrs %{amount: nil, period: nil, periodicity: nil, plan: nil, receipt: nil, status: nil}

    def transaction_fixture(attrs \\ %{}) do
      {:ok, transaction} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_transaction()

      transaction
    end

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Accounts.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Accounts.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      assert {:ok, %Transaction{} = transaction} = Accounts.create_transaction(@valid_attrs)
      assert transaction.amount == Decimal.new("120.5")
      assert transaction.period == 42
      assert transaction.periodicity == "some periodicity"
      assert transaction.plan == "some plan"
      assert transaction.receipt == %{}
      assert transaction.status == "some status"
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()
      assert {:ok, transaction} = Accounts.update_transaction(transaction, @update_attrs)
      assert %Transaction{} = transaction
      assert transaction.amount == Decimal.new("456.7")
      assert transaction.period == 43
      assert transaction.periodicity == "some updated periodicity"
      assert transaction.plan == "some updated plan"
      assert transaction.receipt == %{}
      assert transaction.status == "some updated status"
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_transaction(transaction, @invalid_attrs)
      assert transaction == Accounts.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Accounts.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Accounts.change_transaction(transaction)
    end
  end

  describe "tickets" do
    alias Ptx.Accounts.Ticket

    @valid_attrs %{data: %{}}
    @update_attrs %{data: %{}}
    @invalid_attrs %{data: nil}

    def ticket_fixture(attrs \\ %{}) do
      {:ok, ticket} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_ticket()

      ticket
    end

    test "list_tickets/0 returns all tickets" do
      ticket = ticket_fixture()
      assert Accounts.list_tickets() == [ticket]
    end

    test "get_ticket!/1 returns the ticket with given id" do
      ticket = ticket_fixture()
      assert Accounts.get_ticket!(ticket.id) == ticket
    end

    test "create_ticket/1 with valid data creates a ticket" do
      assert {:ok, %Ticket{} = ticket} = Accounts.create_ticket(@valid_attrs)
      assert ticket.data == %{}
    end

    test "create_ticket/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_ticket(@invalid_attrs)
    end

    test "update_ticket/2 with valid data updates the ticket" do
      ticket = ticket_fixture()
      assert {:ok, ticket} = Accounts.update_ticket(ticket, @update_attrs)
      assert %Ticket{} = ticket
      assert ticket.data == %{}
    end

    test "update_ticket/2 with invalid data returns error changeset" do
      ticket = ticket_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_ticket(ticket, @invalid_attrs)
      assert ticket == Accounts.get_ticket!(ticket.id)
    end

    test "delete_ticket/1 deletes the ticket" do
      ticket = ticket_fixture()
      assert {:ok, %Ticket{}} = Accounts.delete_ticket(ticket)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_ticket!(ticket.id) end
    end

    test "change_ticket/1 returns a ticket changeset" do
      ticket = ticket_fixture()
      assert %Ecto.Changeset{} = Accounts.change_ticket(ticket)
    end
  end
end
