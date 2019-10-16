defmodule Ptx.PagesTest do
  use Ptx.DataCase

  alias Ptx.Pages

  describe "pages" do
    alias Ptx.Pages.Page

    @valid_attrs %{id: "some id", text: "some text", title: "some title"}
    @update_attrs %{id: "some updated id", text: "some updated text", title: "some updated title"}
    @invalid_attrs %{id: nil, text: nil, title: nil}

    def page_fixture(attrs \\ %{}) do
      {:ok, page} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Pages.create_page()

      page
    end

    test "list_pages/0 returns all pages" do
      page = page_fixture()
      assert Pages.list_pages() == [page]
    end

    test "get_page!/1 returns the page with given id" do
      page = page_fixture()
      assert Pages.get_page!(page.id) == page
    end

    test "create_page/1 with valid data creates a page" do
      assert {:ok, %Page{} = page} = Pages.create_page(@valid_attrs)
      assert page.id == "some id"
      assert page.text == "some text"
      assert page.title == "some title"
    end

    test "create_page/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Pages.create_page(@invalid_attrs)
    end

    test "update_page/2 with valid data updates the page" do
      page = page_fixture()
      assert {:ok, page} = Pages.update_page(page, @update_attrs)
      assert %Page{} = page
      assert page.id == "some updated id"
      assert page.text == "some updated text"
      assert page.title == "some updated title"
    end

    test "update_page/2 with invalid data returns error changeset" do
      page = page_fixture()
      assert {:error, %Ecto.Changeset{}} = Pages.update_page(page, @invalid_attrs)
      assert page == Pages.get_page!(page.id)
    end

    test "delete_page/1 deletes the page" do
      page = page_fixture()
      assert {:ok, %Page{}} = Pages.delete_page(page)
      assert_raise Ecto.NoResultsError, fn -> Pages.get_page!(page.id) end
    end

    test "change_page/1 returns a page changeset" do
      page = page_fixture()
      assert %Ecto.Changeset{} = Pages.change_page(page)
    end
  end
end
