defmodule Ptx.Repo.Migrations.CreateTranslations do
  use Ecto.Migration

  def change do
    create table(:translations, primary_key: false) do
      add :id, :string, size: 2, primary_key: true
      add :data, :map
    end
  end
end
