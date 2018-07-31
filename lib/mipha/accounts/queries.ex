defmodule Mipha.Accounts.Queries do
  @moduledoc false

  alias Mipha.Accounts.{User, Team, Company}

  @doc """
  Returns the list users.
  """
  @spec list_users :: Ecto.Query.t()
  def list_users, do: User

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
