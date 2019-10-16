defmodule Ptx.Messages.Context.Link do
  @moduledoc """
  The Link context.
  """

  defmacro __using__(_) do
    quote do
      alias Ptx.Repo
      alias Ptx.Messages.{Link, LinkOpen}
      require OK

      @doc """
      Create transaction and increment count of click in message link.
      Need for statistic.

      ADDED (28.05.2018):
      Now when we increment clicks count me must create a link open.
      """
      def increment_clicks_count(link_id) do
        Repo.transaction(fn ->
          Link
          |> where(id: ^link_id)
          |> Repo.update_all([inc: [clicks_count: 1]])

          create_link_open(%{link_id: link_id})
        end)
      end

      @doc """
      Get message link by given id.
      """
      def get_link(id) do
        Link
        |> where(id: ^id)
        |> Repo.one()
        |> Repo.preload(Link.preloaded())
        |> OK.required(:not_found)
      end

      @doc false
      def create_link_open(attrs \\ %{}) do
        %LinkOpen{}
        |> LinkOpen.changeset(attrs)
        |> Repo.insert()
      end
    end
  end
end
