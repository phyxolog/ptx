defmodule Ptx.Repo.Migrations.AddBlockPixelsFieldToNotificationSettings do
  use Ecto.Migration

  def change do
    alter table(:notification_settings) do
      add :block_pixels, :boolean, default: true, null: false
      add :block_pt_pixels, :boolean, default: false, null: false
    end
  end
end
