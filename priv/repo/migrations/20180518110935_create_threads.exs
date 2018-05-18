defmodule Ptx.Repo.Migrations.CreateThreads do
  use Ecto.Migration

  def change do
    create table(:threads, primary_key: false) do
      add :id, :string, size: 1000, primary_key: true
      timestamps()
    end
  end
end
