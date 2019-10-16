defmodule Ptx.Repo.Migrations.CreateFaqs do
  use Ecto.Migration

  def change do
    create table(:faqs) do
      add :title, :string, size: 512
      add :title_ru, :string, size: 512
      add :title_uk, :string, size: 512
      add :title_en, :string, size: 512
      add :text, :string
      add :text_ru, :text
      add :text_uk, :text
      add :text_en, :text
    end
  end
end
