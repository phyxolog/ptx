defmodule Ptx.Accounts do
  @moduledoc """
  The Accounts context.
  """
  import Ecto.Query, warn: false
  alias Ptx.Repo

  ## Composition of contexts
  use Ptx.Accounts.Context.User
  use Ptx.Accounts.Context.Transaction
  use Ptx.Accounts.Context.Ticket
end
