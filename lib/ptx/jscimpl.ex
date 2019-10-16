defimpl Jason.Encoder, for: Scrivener.Page do
  def encode(value, opts) do
    Jason.Encode.map(Map.from_struct(value), opts)
  end
end
