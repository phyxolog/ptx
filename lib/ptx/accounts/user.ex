defmodule Ptx.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ptx.Accounts.NotificationSettings

  @default_locale Application.get_env(:ptx, PtxWeb.Gettext)[:default_locale]
  @primary_key {:id, :string, [autogenerate: false]}
  @derive {Jason.Encoder, except: [:__meta__, :refresh_token, :access_token, :expires_at]}
  @optional_fields ~w(gender picture locale access_token refresh_token plan full_name
                      token_type expires_at timezone valid_until frozen periodicity)a
  @required_fields ~w(id first_name last_name)a

  @locales Application.get_env(:ptx, PtxWeb.Gettext)[:locales]
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

    has_one :notification_settings, NotificationSettings, on_replace: :update

    timestamps()
  end

  def preloaded, do: [:notification_settings]

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> cast_assoc(:notification_settings, required: true)
    |> validate_required(@required_fields)
    |> validate_inclusion(:plan, Enum.map(@plans, &to_string/1))
    |> validate_inclusion(:periodicity, @periodicities)
    |> validate_inclusion(:locale, @locales)
    |> update_full_name()
    |> validate_change(:timezone, fn _, timezone ->
      if Tzdata.zone_exists?(timezone), do: [], else: [timezone: "invalid timezone"]
    end)
  end

  ## Update full name field
  ## When first_name or last_name changed
  defp update_full_name(changeset) do
    first_name = get_field(changeset, :first_name)
    last_name = get_field(changeset, :last_name)

    put_change(changeset, :full_name, Enum.join([first_name, last_name], " "))
  end
end
