defmodule Ptx.Repo.Migrations.CreatePlans do
  use Ecto.Migration

  def change do
    create table(:plans) do
      add :title, :string, size: 512
      add :title_ru, :string, size: 512
      add :title_uk, :string, size: 512
      add :title_en, :string, size: 512
      add :text, :text
      add :text_ru, :text
      add :text_uk, :text
      add :text_en, :text
    end
  end
end
