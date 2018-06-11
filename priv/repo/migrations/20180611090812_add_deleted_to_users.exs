defmodule Ptx.Repo.Migrations.AddDeletedToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :deleted, :boolean, default: false
    end
  end
end
