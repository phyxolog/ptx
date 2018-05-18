defmodule Ptx.Repo.Migrations.FixMessageIdSizeOnReadList do
  use Ecto.Migration

  def up do
    alter table(:email_read_list) do
      modify :message_id, :string, size: 1000
    end
  end

  def down do
    alter table(:email_read_list) do
      modify :message_id, :string, size: 255
    end
  end
end
