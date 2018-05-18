defmodule Ptx.Messages.Context.Thread do
  @moduledoc """
  The Thread context.
  """

  defmacro __using__(_) do
    quote do
      import Ecto.Query, warn: false
      alias Ptx.Repo

      alias Ptx.Messages.Thread

      @doc """
      Returns the list of threads.

      ## Examples

          iex> list_threads()
          [%Thread{}, ...]

      """
      def list_threads do
        Repo.all(Thread)
      end

      @doc """
      Gets a single thread.

      Raises `Ecto.NoResultsError` if the Thread does not exist.

      ## Examples

          iex> get_thread!(123)
          %Thread{}

          iex> get_thread!(456)
          ** (Ecto.NoResultsError)

      """
      def get_thread!(id), do: Repo.get!(Thread, id)

      @doc """
      Creates a thread.

      ## Examples

          iex> create_thread(%{field: value})
          {:ok, %Thread{}}

          iex> create_thread(%{field: bad_value})
          {:error, %Ecto.Changeset{}}

      """
      def create_thread(attrs \\ %{}) do
        %Thread{}
        |> Thread.changeset(attrs)
        |> Repo.insert()
      end

      @doc """
      Updates a thread.

      ## Examples

          iex> update_thread(thread, %{field: new_value})
          {:ok, %Thread{}}

          iex> update_thread(thread, %{field: bad_value})
          {:error, %Ecto.Changeset{}}

      """
      def update_thread(%Thread{} = thread, attrs) do
        thread
        |> Thread.changeset(attrs)
        |> Repo.update()
      end

      @doc """
      Deletes a Thread.

      ## Examples

          iex> delete_thread(thread)
          {:ok, %Thread{}}

          iex> delete_thread(thread)
          {:error, %Ecto.Changeset{}}

      """
      def delete_thread(%Thread{} = thread) do
        Repo.delete(thread)
      end

      @doc """
      Returns an `%Ecto.Changeset{}` for tracking thread changes.

      ## Examples

          iex> change_thread(thread)
          %Ecto.Changeset{source: %Thread{}}

      """
      def change_thread(%Thread{} = thread) do
        Thread.changeset(thread, %{})
      end
    end
  end
end
