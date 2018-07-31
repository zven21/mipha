defmodule Mipha.Collections.Queries do
  @moduledoc false

  import Ecto.Query
  alias Mipha.Collections.Collection

  @doc """
  Filter the list of collections.

  ## Examples

      iex> cond_collections(params)
      Ecto.Query.t()

  """
  @spec cond_collections(Keyword.t()) :: Ecto.Query.t()
  def cond_collections(opts \\ []) do
    opts
    |> filter_from_clauses
    |> preload([:user, [topic: :node]])
  end

  defp filter_from_clauses(opts) do
    cond do
      Keyword.has_key?(opts, :user) -> opts |> Keyword.get(:user) |> Collection.by_user
      Keyword.has_key?(opts, :topic) -> opts |> Keyword.get(:topic) |> Collection.by_topic
      true -> Collection
    end
  end
end
