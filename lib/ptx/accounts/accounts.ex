defmodule Ptx.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  require OK
  alias Ptx.Repo

  alias Ptx.Accounts.User

  @doc """
  Find or create user with given params.
  """
  def find_or_create_user(%{id: id} = attrs) do
    case fetch_user(id: id) do
      {:error, :not_found} -> create_user(attrs)
      user -> user
    end
  end

  @doc """
  Gets a single user with given filters.
  Filters doesn't support associations.
  And in filters not allow `nil`.
  Because for find by `nil` we must use is_nil/1 instead.
  """
  def fetch_user(opts \\ []) do
    User
    |> where(^opts)
    |> limit(1)
    |> Repo.one()
    |> Repo.preload(User.preloaded())
    |> OK.required(:not_found)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end
end
