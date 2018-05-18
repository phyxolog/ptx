defmodule Ptx.Messages.Context.Link do
  @moduledoc """
  The Link context.
  """

  defmacro __using__(_) do
    quote do
      alias Ptx.Repo
      alias Ptx.Messages.Link
      require OK

      @doc """
      Create transaction and increment count of click in message link.
      Need for statistic.
      """
      def increment_clicks_count(link_id) do
        Repo.transaction(fn ->
          Link
          |> where(id: ^link_id)
          |> Repo.update_all([inc: [clicks_count: 1]])
        end)
      end

      @doc """
      Get message link by given id.
      """
      def get_link(id) do
        Link
        |> where(id: ^id)
        |> Repo.one()
        |> OK.required(:not_found)
      end
    end
  end
end
