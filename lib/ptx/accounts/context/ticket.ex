defmodule Ptx.Accounts.Context.Ticket do
  @moduledoc """
  The Ticket context.
  """

  defmacro __using__(_) do
    quote do
      alias Ptx.Repo
      alias Ptx.Accounts.Ticket

      @doc """
      Creates a ticket.

      ## Examples

          iex> create_ticket(%{field: value})
          {:ok, %Ticket{}}

          iex> create_ticket(%{field: bad_value})
          {:error, %Ecto.Changeset{}}

      """
      def create_ticket(attrs \\ %{}) do
        %Ticket{}
        |> Ticket.changeset(attrs)
        |> Repo.insert()
      end
    end
  end
end
