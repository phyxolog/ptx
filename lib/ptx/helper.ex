defmodule Ptx.Helper do
  @doc """
  First off, transform erlang term to binary
  then - encode base64
  """
  def encode_term(term) do
    term
    |> :erlang.term_to_binary()
    |> Base.encode64()
  end

  @doc """
  First off, decode base64
  then - transform binary to erlang term
  """
  def decode_term(binary) do
    binary
    |> Base.decode64!()
    |> :erlang.binary_to_term()
  end

  @doc """
  Transform non standart url (without anchor) to url with anchor.
  """
  def transform_url("http://" <> _url = link), do: {:ok, link}
  def transform_url("https://" <> _url = link), do: {:ok, link}
  def transform_url("ftp://" <> _url = link), do: {:ok, link}
  def transform_url(url) do
    case URI.parse(url)do
      %URI{host: nil, path: path} when is_binary(path) -> {:ok, "//" <> path}
      %URI{host: host} = uri when is_binary(host) -> {:ok, URI.to_string(uri)}
      _ -> {:error, :invalid_uri}
    end
  end
end
