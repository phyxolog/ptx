defmodule Ptx.Repo.Migrations.CreateNotificationSettings do
  use Ecto.Migration

  def change do
    create table(:notification_settings) do
      add :email_readed, :boolean, default: true, null: false
      add :link_opened, :boolean, default: true, null: false
      add :pw_changed, :boolean, default: true, null: false
      add :plan_changed, :boolean, default: true, null: false
      add :user_id, references(:users, type: :string, on_delete: :delete_all)
    end

    create index(:notification_settings, [:user_id])
  end
end
