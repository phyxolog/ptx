defmodule Ptx.Accounts.NotificationSettings do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ptx.Accounts.User

  @derive {Jason.Encoder, except: [:__meta__, :id, :user, :user_id]}
  @fields ~w(change_plan change_pw email_readed link_opened)a

  schema "notification_settings" do
    field :change_plan, :boolean, default: true
    field :change_pw, :boolean, default: true
    field :email_readed, :boolean, default: true
    field :link_opened, :boolean, default: true
    belongs_to :user, User, type: :string
  end

  @doc false
  def changeset(notification_setting, attrs) do
    notification_setting
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
