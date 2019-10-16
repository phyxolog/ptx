defmodule Ptx.Repo.Migrations.FixUserIdSizeOnNotificationSettings do
  use Ecto.Migration

  def up do
    alter table(:notification_settings) do
      modify :user_id, :string, size: 320
    end
  end

  def down do
    alter table(:notification_settings) do
      modify :user_id, :string, size: 255
    end
  end
end
