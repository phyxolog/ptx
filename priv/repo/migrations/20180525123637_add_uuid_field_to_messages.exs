defmodule Ptx.Repo.Migrations.AddUuidFieldToMessages do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :uuid, :uuid
    end

    create unique_index(:messages, [:uuid])
  end
end
