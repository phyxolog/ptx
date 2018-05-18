defmodule Ptx.Messages do
  @moduledoc """
  The Messages context.
  """

  import Ecto.Query, warn: false
  alias Ptx.Repo

  use Ptx.Messages.Context.Message
  use Ptx.Messages.Context.Thread
  use Ptx.Messages.Context.Read
end
