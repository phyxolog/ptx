defmodule Ptx.Messages.Context.Read do
  @moduledoc """
  The Read context.
  """

  defmacro __using__(_) do
    quote do
      alias Ptx.Repo
      alias Ptx.Messages.Read

      @doc """
      Creates a email read.

      ## Examples

          iex> create_email_read(%{field: value})
          {:ok, %Read{}}

          iex> create_email_read(%{field: bad_value})
          {:error, %Ecto.Changeset{}}

      """
      def create_email_read(attrs \\ %{}) do
        %Read{}
        |> Read.changeset(attrs)
        |> Repo.insert()
      end
    end
  end
end
