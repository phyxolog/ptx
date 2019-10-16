defmodule Ptx.Repo.Migrations.AddFaqCategoryToFaqs do
  use Ecto.Migration

  def change do
    alter table(:faqs) do
      add :category_id, references(:faq_categories, on_delete: :delete_all)
    end

    create index(:faqs, [:category_id])
  end
end
