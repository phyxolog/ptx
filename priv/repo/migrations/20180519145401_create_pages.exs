defmodule Ptx.Repo.Migrations.CreatePages do
  use Ecto.Migration

  def change do
    create table(:pages, primary_key: false) do
      add :id, :string, primary_key: true
      add :title, :string
      add :title_ru, :string
      add :title_uk, :string
      add :title_en, :string
      add :text, :text
      add :text_ru, :text
      add :text_uk, :text
      add :text_en, :text
    end
  end
end
