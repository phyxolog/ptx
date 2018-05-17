defmodule Ptx.TranslationsTest do
  use Ptx.DataCase

  alias Ptx.Translations

  describe "translations" do
    alias Ptx.Translations.Translation

    @valid_attrs %{data: %{}}
    @update_attrs %{data: %{}}
    @invalid_attrs %{data: nil}

    def translation_fixture(attrs \\ %{}) do
      {:ok, translation} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Translations.create_translation()

      translation
    end

    test "list_translations/0 returns all translations" do
      translation = translation_fixture()
      assert Translations.list_translations() == [translation]
    end

    test "get_translation!/1 returns the translation with given id" do
      translation = translation_fixture()
      assert Translations.get_translation!(translation.id) == translation
    end

    test "create_translation/1 with valid data creates a translation" do
      assert {:ok, %Translation{} = translation} = Translations.create_translation(@valid_attrs)
      assert translation.data == %{}
    end

    test "create_translation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Translations.create_translation(@invalid_attrs)
    end

    test "update_translation/2 with valid data updates the translation" do
      translation = translation_fixture()
      assert {:ok, translation} = Translations.update_translation(translation, @update_attrs)
      assert %Translation{} = translation
      assert translation.data == %{}
    end

    test "update_translation/2 with invalid data returns error changeset" do
      translation = translation_fixture()
      assert {:error, %Ecto.Changeset{}} = Translations.update_translation(translation, @invalid_attrs)
      assert translation == Translations.get_translation!(translation.id)
    end

    test "delete_translation/1 deletes the translation" do
      translation = translation_fixture()
      assert {:ok, %Translation{}} = Translations.delete_translation(translation)
      assert_raise Ecto.NoResultsError, fn -> Translations.get_translation!(translation.id) end
    end

    test "change_translation/1 returns a translation changeset" do
      translation = translation_fixture()
      assert %Ecto.Changeset{} = Translations.change_translation(translation)
    end
  end
end
