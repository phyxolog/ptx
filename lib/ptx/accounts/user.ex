defmodule Ptx.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @default_locale Application.get_env(:ptx, PtxWeb.Gettext)[:default_locale]
  @primary_key {:id, :string, [autogenerate: false]}
  @derive {Jason.Encoder, except: [:__meta__, :refresh_token, :access_token, :expires_at]}
  @optional_fields ~w(gender picture locale access_token refresh_token plan
                      token_type expires_at timezone valid_until frozen periodicity)a
  @required_fields ~w(id first_name last_name full_name)a

  @plans Application.get_env(:ptx, :plans)
  @periodicities ~w(month year)

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :full_name, :string
    field :gender, :string
    field :picture, :string
    field :locale, :string, default: @default_locale
    field :timezone, :string, default: "UTC"

    field :plan, :string, default: nil
    field :frozen, :boolean, default: true
    field :valid_until, :naive_datetime, default: nil
    field :periodicity, :string, default: nil
    field :previous_plan, :string, default: nil ## Only for read. Changing by sql trigger.

    ## Google OAuth2
    field :token_type, :string
    field :access_token, :string
    field :refresh_token, :string
    field :expires_at, :integer

    timestamps()
  end

  def preloaded, do: []

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
    |> validate_inclusion(:plan, Enum.map(@plans, &to_string/1))
    |> validate_inclusion(:periodicity, @periodicities)
  end
end
