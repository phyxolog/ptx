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
end
