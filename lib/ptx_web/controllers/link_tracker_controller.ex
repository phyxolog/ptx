defmodule PtxWeb.LinkTrackerController do
  use PtxWeb, :controller
  alias Ptx.{Messages, MailNotifier}

  action_fallback PtWeb.FallbackController

  def index(conn, %{"url" => url, "id" => message_id, "link_id" => link_id}) do
    Messages.increment_clicks_count(link_id)
    MailNotifier.open_link_notify(message_id, link_id)

    case Base.decode64(url) do
      {:ok, url} ->
        case Ptx.Helper.transform_url(url) do
          {:ok, url} -> redirect(conn, external: url)
          {:error, _} -> {:error, {:reason, "Invalid url"}}
        end
      _ -> {:error, {:reason, "Invalid url"}}
    end
  end
end
