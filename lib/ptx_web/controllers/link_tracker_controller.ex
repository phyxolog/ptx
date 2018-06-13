defmodule PtxWeb.LinkTrackerController do
  use PtxWeb, :controller
  alias Ptx.{Messages, MailNotifier}

  action_fallback PtxWeb.FallbackController

  ## Check if available notify for user
  defp can_notify?(user, link, field) do
    cond do
      link.clicks_count <= 1 && Map.get(user.notification_settings, field) ->
        true
      link.clicks_count > 1 && Map.get(user.notification_settings, String.to_existing_atom("#{field}_again")) ->
        true
      true ->
        false
    end
  end

  ## TODO: Refactoring
  def index(conn, %{"url" => url, "uuid" => message_uuid, "link_id" => link_id}) do
    Task.start(fn ->
      user = Messages.get_user_by_message_uuid(message_uuid)
      Messages.increment_clicks_count(link_id)

      with {:ok, message} <- Messages.get_message_by_uuid(message_uuid),
           {:ok, link} <- Messages.get_link(link_id) do

        if can_notify?(user, link, :link_opened) do
          MailNotifier.open_link_notify(message, link, user)
        end

        if can_notify?(user, link, :push_link_opened) do
          PtxWeb.Endpoint.broadcast("room:#{user.id}", "link_clicked", %{
            subject: message.subject,
            recipient: Messages.get_message_recipient(message),
            link_text: link.text
          })
        end
      end
    end)

    case Ptx.Helper.transform_url(URI.decode(url)) do
      {:ok, url} -> redirect(conn, external: url)
      {:error, _} -> {:error, {:reason, "Invalid url"}}
    end
  end
end
