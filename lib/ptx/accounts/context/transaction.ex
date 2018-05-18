defmodule Ptx.Accounts.Context.Transaction do
  @moduledoc """
  The Transaction context.
  """

  defmacro __using__(_) do
    quote do
      import Ecto.Query, warn: false
      alias Ptx.Repo

      alias Ptx.Accounts.Transaction

      @doc """
      Fetch transaction with given filters.
      """
      def fetch_transaction(opts \\ []) do
        Transaction
        |> where(^opts)
        |> limit(1)
        |> Repo.one()
        |> OK.required(:not_found)
      end

      @doc """
      Creates a transaction.

      ## Examples

          iex> create_transaction(%{field: value})
          {:ok, %Transaction{}}

          iex> create_transaction(%{field: bad_value})
          {:error, %Ecto.Changeset{}}

      """
      def create_transaction(attrs \\ %{}) do
        %Transaction{}
        |> Transaction.changeset(attrs)
        |> Repo.insert()
      end

      @doc """
      Updates a transaction.

      ## Examples

          iex> update_transaction(transaction, %{field: new_value})
          {:ok, %Transaction{}}

          iex> update_transaction(transaction, %{field: bad_value})
          {:error, %Ecto.Changeset{}}

      """
      def update_transaction(%Transaction{} = transaction, attrs) do
        transaction
        |> Transaction.changeset(attrs)
        |> Repo.update()
      end
    end
  end
end
