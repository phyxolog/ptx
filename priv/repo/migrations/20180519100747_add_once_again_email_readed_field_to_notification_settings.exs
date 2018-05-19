defmodule Ptx.Repo.Migrations.AddOnceAgainEmailReadedFieldToNotificationSettings do
  use Ecto.Migration

  def change do
    alter table(:notification_settings) do
      add :once_again_readed_email, :boolean, null: false, default: true
    end
  end
end
