defmodule Mipha.Ransack.Search do
  @moduledoc """
  Single Table Search
  """

  alias Mipha.Ransack.Services.BuildSearchQuery
  alias Mipha.Ransack.Utils
  alias Mipha.Repo

  @search_type ~w(eq like)a

  @doc """
  直接返回搜索结果
  """
  def run(queryable, params) do
    queryable
    |> runq(params)
    |> Repo.all()
  end

  @doc """
  返回搜索的 queryable
  """
  def runq(queryable, search_params), do: handle_search(queryable, search_params)

  defp handle_search(queryable, search_params) do
    search_params
    |> Map.get("q", %{})
    |> Map.to_list()
    |> Enum.reduce(queryable, &build_search_params(&1, &2))
  end

  # 目前只适合单表的处理逻辑，需要改进支持多表多字段处理。
  defp build_search_params(param, queryable) do
    field_and_type = elem(param, 0)
    search_term = elem(param, 1)

    field_and_type
    |> String.split("_")
    |> search_queryable(search_term, queryable)
  end

  # 目前仅支持 where 的判断， 不支持 or_where 的处理
  defp search_queryable([search_field, search_type] = fieldtype, search_term, queryable) when length(fieldtype) == 2 do
    search_field = String.to_atom(search_field)
    search_type = String.to_atom(search_type)
    queryable = Utils.schema_from_query(queryable)
    search_expr = :where

    if search_field in queryable.__schema__(:fields) && search_type in @search_type do
      BuildSearchQuery.run(queryable, search_field, {search_expr, search_type}, search_term)
    else
      queryable
    end
  end
  defp search_queryable(_, _, queryable), do: queryable
end
