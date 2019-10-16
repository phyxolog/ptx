defmodule Ptx.Repo.Migrations.FixSizeOfForeignKeysInMessages do
  use Ecto.Migration

  def up do
    alter table(:messages) do
      modify :sender_id, :string, size: 320
      modify :thread_id, :string, size: 1000
    end
  end

  def down do
    alter table(:messages) do
      modify :sender_id, :string, size: 255
      modify :thread_id, :string, size: 255
    end
  end
end
