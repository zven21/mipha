defmodule Mipha.Ransack.Utils do
  @moduledoc false

  @doc """
  返回 queryable 的 schema 信息

  ## Example

      iex> schema_from_query(Topic)
      Topic
      iex> schema_from_query(#Ecto.Query<from t in subquery(from t in Mipha.Topics.Topic)>)
      Topic

  """
  @spec schema_from_query(Ecto.Query.t()) :: Ecto.Query.t()
  def schema_from_query(queryable) do
    case queryable do
      %{from: %{query: subquery}} -> schema_from_query(subquery)
      %{from: {_, schema}} -> schema
      _ -> queryable
    end
  end
end
