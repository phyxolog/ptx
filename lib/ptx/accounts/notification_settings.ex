defmodule Ptx.Accounts.NotificationSettings do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ptx.Accounts.User

  @derive {Jason.Encoder, except: [:__meta__, :id, :user, :user_id]}
  @fields ~w(plan_changed pw_changed email_readed link_opened once_again_readed_email)a

  schema "notification_settings" do
    field :plan_changed, :boolean, default: true
    field :pw_changed, :boolean, default: true
    field :email_readed, :boolean, default: true
    field :link_opened, :boolean, default: true
    field :once_again_readed_email, :boolean, default: true
    belongs_to :user, User, type: :string
  end

  @doc false
  def changeset(notification_setting, attrs) do
    notification_setting
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
