defmodule Ptx.Repo.Migrations.AddPushFieldsToNotificationSettings do
  use Ecto.Migration

  def change do
    alter table(:notification_settings) do
      add :push_email_read, :boolean, default: true
      add :push_email_read_again, :boolean, default: false
    end
  end
end
