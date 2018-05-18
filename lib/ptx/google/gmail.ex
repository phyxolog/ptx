defmodule Ptx.Google.Gmail do
  use HTTPoison.Base

  require Logger

  # alias Ptx.Google.OAuth

  ## LEGACY

  # Ptx.Google.Gmail.inject_pixel_to_draft("r8998778023019203938", "yzhivaga@gmail.com", user)

  # def inject_pixel_to_draft(draft_id, user_id, user) do
  #   # body = get_draft(draft_id, user_id, user)
  #   # |> OK.bind(&inject_pixel_to_draft/1)

  #   # put_draft(body, draft_id, user_id, user)
  # end

  # defp generate_and_inject_pixel(%{"data" => data} = body) do
  #   ## TODO: Generate email pixel
  #   data = data <> "my kek pixel"
  #   %{body | "data" => Base.encode64(data), "size" => byte_size(data)}
  # end

  # defp inject_pixel_to_draft(body) do
  #   payload_body = get_in(body, ["message", "payload", "body"])
  #   payload_body = generate_and_inject_pixel(payload_body)
  #   put_in(body, ["message", "payload", "body"], payload_body)
  #   # parts = get_in(body, ["message", "payload", "parts"])
  #   # |> OK.required(:not_found)
  #   # |> OK.bind(fn parts -> {:ok, Enum.map(parts, &process_part/1)} end)

  #   # case parts do
  #   #   {:ok, parts} ->
  #   #     body
  #   #     |> put_in(["message", "payload", "parts"], parts)
  #   #   _ -> body
  #   # end
  # end

  # # ## Process each part in draft
  # # defp process_part(part) do
  # #   case Base.decode64(part["body"]["data"]) do
  # #     {:ok, data} ->
  # #       ## TODO: Generate email pixel
  # #       data = generate_and_inject_pixel(data)

  # #       part
  # #       |> put_in(["body", "data"], Base.encode64(data))
  # #       |> put_in(["body", "size"], byte_size(data))
  # #     _ -> part
  # #   end
  # # end

  # ## Get draft from Gmail by id
  # defp get_draft(draft_id, user_id, user) do
  #   OAuth.get_user_token(user)
  #   |> OK.bind(fn token ->
  #     get("/users/#{user_id}/drafts/#{draft_id}", auth_header(token))
  #   end)
  #   |> OK.bind(fn
  #     %{body: body} -> {:ok, body}
  #     _ -> {:error, :request_error}
  #   end)
  # end

  # ## Save draft
  # # defp put_draft(body, draft_id, user_id, user) do
  # #   OAuth.get_user_token(user)
  # #   |> OK.bind(fn token ->
  # #     # IO.inspect body
  # #     # "https://www.googleapis.com/gmail/v1/users/#{user_id}/drafts"
  # #     # "https://www.googleapis.com/gmail/v1/users/#{user_id}/drafts"
  # #     # |> HTTPoison.post(Jason.encode!(%{"message" => body["message"]}), auth_header(token) ++ ["Content-Type": "application/json"])
  # #     # |> IO.inspect
  # #   end)
  # # end

  # ## Return auth header keyword.
  # defp auth_header(token) do
  #   [authorization: "Bearer #{token}"]
  # end

  # def process_url(url) do
  #   "https://www.googleapis.com/gmail/v1" <> url
  # end

  # def process_response_body(body) do
  #   Jason.decode!(body)
  # end
end
