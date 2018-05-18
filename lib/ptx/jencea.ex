defimpl Jason.Encoder, for: Ecto.Association.NotLoaded do
  def encode(_value, _opts) do
    "null"
  end
end
