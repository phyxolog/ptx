defmodule Ptx.Repo.Migrations.AddLinkOpenedAgainToNotificationSettings do
  use Ecto.Migration

  def change do
    alter table(:notification_settings) do
      add :link_opened_again, :boolean, default: true
    end
  end
end
