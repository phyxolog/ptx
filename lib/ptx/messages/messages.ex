defmodule Ptx.Messages do
  @moduledoc """
  The Messages context.
  """

  import Ecto.Query, warn: false
  alias Ptx.Repo

  ## Composition of contexts
  use Ptx.Messages.Context.Message
  use Ptx.Messages.Context.Thread
  use Ptx.Messages.Context.Read
  use Ptx.Messages.Context.Link
end
