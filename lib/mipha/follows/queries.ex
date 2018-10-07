defmodule Mipha.Follows.Queries do
  @moduledoc """
  Query Follows Contetxt.
  """
  import Ecto.Query
  alias Mipha.Follows.Follow

  @doc """
  Filter the list of topics.

  ## Examples

      iex> cond_follows(params)
      Ecto.Query.t()

      iex> cond_follows(params, user: %User{})
      Ecto.Query.t()

      iex> cond_follows(params, follower: %User{})
      Ecto.Query.t()

  """
  @spec cond_follows(Keyword.t()) :: Ecto.Query.t()
  def cond_follows(opts \\ []) do
    opts
    |> filter_from_clauses
    |> preload([:user, :follower])
  end

  defp filter_from_clauses(opts) do
    cond do
      Keyword.has_key?(opts, :follower) -> opts |> Keyword.get(:follower) |> Follow.by_follower()
      Keyword.has_key?(opts, :user) -> opts |> Keyword.get(:user) |> Follow.by_user()
      true -> Follow
    end
  end
end
