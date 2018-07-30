defmodule Mipha.Accounts.Queries do
  @moduledoc false

  alias Mipha.Accounts.{User, Team}

  @doc """
  Returns the list users.
  """
  @spec users(Map.t()) :: Map.t()
  def users(params), do: Trubo.Ecto.trubo(User, params)

  @doc """
  Returns the list teams.
  """
  @spec teams(Map.t()) :: Map.t()
  def teams(params), do: Trubo.Ecto.trubo(Team, params)
end
