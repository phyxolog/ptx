defmodule Ptx.Repo.Migrations.RenameFieldsInNotitifationSettings1 do
  use Ecto.Migration

  def change do
    rename table("notification_settings"), :email_readed, to: :email_read
    rename table("notification_settings"), :once_again_readed_email, to: :email_opened_again

    alter table(:notification_settings) do
      remove :pw_changed
    end
  end
end
