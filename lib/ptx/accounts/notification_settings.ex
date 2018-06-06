defmodule Ptx.Accounts.NotificationSettings do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ptx.Accounts.User

  @derive {Poison.Encoder, except: [:__meta__, :id, :user, :user_id]}
  @derive {Jason.Encoder, except: [:__meta__, :id, :user, :user_id]}
  @fields ~w(plan_changed email_read link_opened email_opened_again link_opened_again)a

  schema "notification_settings" do
    field :plan_changed, :boolean, default: true
    field :email_read, :boolean, default: true
    field :email_opened_again, :boolean, default: true
    field :link_opened, :boolean, default: true
    field :link_opened_again, :boolean, default: true
    belongs_to :user, User, type: :string
  end

  @doc false
  def changeset(notification_setting, attrs) do
    notification_setting
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
