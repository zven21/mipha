defmodule Mipha.Topics.Queries do
  @moduledoc false

  import Ecto.Query
  alias Mipha.Topics.{Topic, Node}

  @doc """
  Returns the list topics.
  """
  @spec list_topics :: Ecto.Query.t()
  def list_topics, do: Topic

  @doc """
  Returns the list nodes.
  """
  @spec list_nodes :: Ecto.Query.t()
  def list_nodes, do: Node

  @doc """
  Returns the the type equal job topics.
  """
  @spec job_topics :: Ecto.Query.t()
  def job_topics do
    Topic.job()
    |> preload([:user, :node, :last_reply_user])
  end

  @doc """
  Filter the list of topics.

  ## Examples

      iex> cond_topics()
      Ecto.Query.t()

      iex> cond_topics(type: :educational)
      Ecto.Query.t()

      iex> cond_topics(node: %Node{})
      Ecto.Query.t()

      iex> cond_topics(user: %User{})
      Ecto.Query.t()

  """
  @spec cond_topics(Keyword.t()) :: Ecto.Query.t()
  def cond_topics(opts) do
    opts
    |> filter_from_clauses
    |> Topic.base_order()
    |> preload([:user, :node, :last_reply_user])
  end

  defp filter_from_clauses(opts), do: do_filter_from_clauses(opts)

  defp do_filter_from_clauses(type: :educational), do: Topic.educational()
  defp do_filter_from_clauses(type: :featured), do: Topic.featured()
  defp do_filter_from_clauses(type: :no_reply), do: Topic.no_reply()
  defp do_filter_from_clauses(type: :popular), do: Topic.popular()
  defp do_filter_from_clauses(node: node), do: Topic.by_node(node)
  defp do_filter_from_clauses(user: user), do: Topic.by_user(user)
  defp do_filter_from_clauses(user_ids: user_ids), do: Topic.by_user_ids(user_ids)
  defp do_filter_from_clauses(_), do: Topic
end
