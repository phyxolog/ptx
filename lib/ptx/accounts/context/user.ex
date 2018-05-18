defmodule Ptx.Accounts.Context.User do
  @moduledoc """
  The User context.
  """

  defmacro __using__(_) do
    quote do
      import Ecto.Query, warn: false
      alias Ptx.Repo

      alias Ptx.Accounts.User

      @trial_period Application.get_env(:ptx, :trial_period, 14)

      @doc """
      Freeze user. Check only by valid_until.
      Call every 2 hours.
      """
      def freeze_expired_users do
        query = from u in User,
          where: fragment("(? - CURRENT_TIMESTAMP AT TIME ZONE 'UTC')::interval < interval '0 days'", u.valid_until)

        Repo.update_all(query, set: [frozen: true])
      end

      @doc """
      Get user by token.
      Used Guardian.
      """
      def get_user_by_token(token) do
        try do
          {:ok, resource, _claims} = Ptx.Guardian.resource_from_token(token)
          resource
        rescue
          _ -> nil
        end
      end

      @doc """
      Deteting old transaction by user.
      """
      def delete_old_user_transactions(user_id) do
        Transaction
        |> where(user_id: ^user_id)
        |> Repo.delete_all()
      end

      @doc """

      """
      def refresh_access_token(user) do
        case user do
          %{refresh_token: nil} ->
            {:error, :empty_refresh_token}
          %{refresh_token: refresh_token} ->
            Ptx.Google.OAuth.get_new_access_token(refresh_token)
            |> OK.bind(fn
              %{access_token: access_token, expires_in: expires_in, token_type: token_type} ->
                update_user(user, %{
                  access_token: access_token,
                  token_type: token_type,
                  expires_at: :os.system_time(:seconds) + expires_in
                })
            end)
        end
      end

      @doc """
      Activate user trial period (if available)
      """
      def activate_user_trial(user) do
        case trial_available?(user) do
          true ->
            update_user(user, %{
              plan: "trial",
              frozen: false,
              valid_until: Timex.shift(Timex.now(), days: @trial_period)
            })

            {:ok, :activated}
          false ->
            {:error, :unavailable}
        end
      end

      @doc """
      Check valid user by `valid_until` field.
      If now() > `valid_until` return false.
      """
      def valid_now?(user), do: Timex.before?(user.valid_until, Timex.now())

      @doc """
      Check available for trial plan.
      """
      def trial_available?(%{inserted_at: inserted_at, plan: plan, previous_plan: previous_plan}) do
        plan == nil && previous_plan == nil && Timex.diff(Timex.now(), inserted_at, :days) < @trial_period
      end

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
    end
  end
end
