defmodule PtxWeb.LinkTrackerController do
  use PtxWeb, :controller
  alias Ptx.{Messages, MailNotifier}

  action_fallback PtxWeb.FallbackController

  def index(conn, %{"url" => url, "uuid" => message_uuid, "link_id" => link_id}) do
    Messages.increment_clicks_count(link_id)
    MailNotifier.open_link_notify(message_uuid, link_id)

    case Ptx.Helper.transform_url(URI.decode(url)) do
      {:ok, url} -> redirect(conn, external: url)
      {:error, _} -> {:error, {:reason, "Invalid url"}}
    end
  end
end
