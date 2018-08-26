defmodule Mipha.Accounts.Queries do
  @moduledoc false

  alias Mipha.Accounts.{User, Team, Company}
  import Ecto.Query

  @doc """
  Returns the list users.
  """
  @spec list_users :: Ecto.Query.t()
  def list_users, do: User |> order_by([q], asc: q.inserted_at)

  @doc """
  Returns the list teams.
  """
  @spec list_teams :: Ecto.Query.t()
  def list_teams, do: Team

  @doc """
  Returns the list companies.
  """
  @spec list_companies :: Ecto.Query.t()
  def list_companies, do: Company
end
