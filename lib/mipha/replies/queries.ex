defmodule Mipha.Replies.Queries do
  @moduledoc false

  import Ecto.Query
  alias Mipha.Replies.Reply

  @doc """
  Returns the list replies.
  """
  @spec list_replies :: Ecto.Query.t()
  def list_replies, do: Reply

  @doc """
  Filter the list of repies.

  ## Examples

      iex> cond_replies(params)
      Ecto.Query.t()

      iex> cond_replies(params, user: %User{})
      Ecto.Query.t()

  """
  @spec cond_replies(Keyword.t()) :: Ecto.Query.t()
  def cond_replies(opts) do
    opts
    |> filter_from_clauses
    |> preload([:topic, :user])
  end

  defp filter_from_clauses(opts) do
    cond do
      Keyword.has_key?(opts, :user) -> opts |> Keyword.get(:user) |> Reply.by_user
      Keyword.has_key?(opts, :topic) -> opts |> Keyword.get(:topic) |> Reply.by_topic
      true -> Reply
    end
  end
end
