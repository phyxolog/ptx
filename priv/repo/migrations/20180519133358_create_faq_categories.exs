defmodule Ptx.Repo.Migrations.CreateFaqCategories do
  use Ecto.Migration

  def change do
    create table(:faq_categories) do
      add :title, :string
      add :title_ru, :string
      add :title_uk, :string
      add :title_en, :string
    end
  end
end
