defmodule Ptx.Repo.Migrations.AddUniqueIndexToNotificationSettings do
  use Ecto.Migration

  def change do
    create unique_index(:notification_settings, [:user_id], name: :notification_settings_user_id_unique_index)
  end
end
