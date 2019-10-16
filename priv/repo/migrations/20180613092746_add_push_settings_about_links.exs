defmodule Ptx.Repo.Migrations.AddPushSettingsAboutLinks do
  use Ecto.Migration

  def change do
    alter table(:notification_settings) do
      add :push_link_opened, :boolean, default: true
      add :push_link_opened_again, :boolean, default: false
    end
  end
end
