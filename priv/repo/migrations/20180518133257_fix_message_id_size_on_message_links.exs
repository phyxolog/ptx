defmodule Ptx.Repo.Migrations.FixMessageIdSizeOnMessageLinks do
  use Ecto.Migration

  def up do
    alter table(:message_links) do
      modify :message_id, :string, size: 1000
    end
  end

  def down do
    alter table(:message_links) do
      modify :message_id, :string, size: 255
    end
  end
end
