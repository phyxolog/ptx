defmodule Ptx.Repo.Migrations.CreateThreads do
  use Ecto.Migration

  def change do
    create table(:threads) do
      add :id, :string

      timestamps()
    end

  end
end
