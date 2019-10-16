defmodule Ptx.Accounts.NotificationSettings do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ptx.Accounts.User

  @derive {Poison.Encoder, except: [:__meta__, :id, :user, :user_id]}
  @derive {Jason.Encoder, except: [:__meta__, :id, :user, :user_id]}
  @fields ~w(
    plan_changed
    email_read email_opened_again
    link_opened link_opened_again
    push_email_read push_email_read_again
    push_link_opened push_link_opened_again
    block_pixels
    block_pt_pixels
  )a

  schema "notification_settings" do
    field :plan_changed, :boolean, default: true
    field :email_read, :boolean, default: true
    field :email_opened_again, :boolean, default: false
    field :link_opened, :boolean, default: true
    field :link_opened_again, :boolean, default: false
    field :push_email_read, :boolean, default: true
    field :push_email_read_again, :boolean, default: false
    field :push_link_opened, :boolean, default: true
    field :push_link_opened_again, :boolean, default: false
    field :block_pixels, :boolean, default: true
    field :block_pt_pixels, :boolean, default: false
    belongs_to :user, User, type: :string
  end

  @doc false
  def changeset(notification_setting, attrs) do
    notification_setting
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
