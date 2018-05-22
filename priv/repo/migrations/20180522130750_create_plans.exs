defmodule Ptx.Repo.Migrations.CreatePlans do
  use Ecto.Migration

  def change do
    create table(:plans) do
      add :title, :string, size: 512
      add :title_ru, :string, size: 512
      add :title_uk, :string, size: 512
      add :title_en, :string, size: 512
      add :text, :string
      add :text_ru, :string
      add :text_uk, :string
      add :text_en, :string
    end
  end
end
