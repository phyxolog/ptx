defmodule Ptx.Repo.Migrations.AddElitaInUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :is_elite, :boolean, default: false, null: false
    end
  end
end
