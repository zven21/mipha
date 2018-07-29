defmodule Mipha.Ransack.Paginate do
  @moduledoc """
  Single table Paginate.
  """

  import Ecto.Query
  alias Mipha.Repo

  @per_page 10

  @doc """
  直接返回 Paginate 的数据和「分页」信息

  ## Example

      iex> params = %{"per_page" => 10, "page" => 2}
      iex> Mipha.Ransack.Paginate.run(Mipha.Topics.Topic, params)
      %{
        paginate: %{max_page: 2, page: 2, per_page: 5, total_count: 10},
        result: [%Mipha.Topics.Topic{}]
      }

  """
  @spec run(Ecto.Query.t(), map()) :: Map.t()
  def run(queryable, params) do
    %{
      result: runq(queryable, params),
      paginate: get_paginate(queryable, params)
    }
  end

  @doc """
  返回 Paginate 的 queryable.

  ## Example

      iex> params = %{"per_page" => 5, "page" => 2}
      iex> Mipha.Ransack.Paginate.runq(Mipha.Topics.Topic, params)
      #Ecto.Query<from t in Mipha.Topics.Topic, limit: ^5, offset: ^5>

  """
  @spec runq(Ecto.Query.t(), Map.t()) :: Ecto.Query.t()
  def runq(queryable, params) do
    params
    |> format_params()
    |> handle_paginate(queryable)
  end

  # 格式填充 paginate params
  # 可能获取的是 string 类型，不太好。
  defp format_params(params) do
    params
    |> Map.put_new(:per_page, format_integer(Map.get(params, "per_page", @per_page)))
    |> Map.put_new(:page, format_integer(Map.get(params, "page", 1)))
  end

  # build queryable
  defp handle_paginate(formated_params, queryable) do
    per_page = Map.get(formated_params, :per_page)
    page = Map.get(formated_params, :page)

    offset = per_page * (page - 1)

    queryable
    |> limit(^per_page)
    |> offset(^offset)
  end

  # 格式化数据，如果是 string 类型，修改成 integer.
  defp format_integer(value) do
    unless is_integer(value), do: String.to_integer(value), else: value
  end

  def get_paginate(queryable, params) do
    formated_params = format_params(params)

    per_page = Map.get(formated_params, :per_page)
    total_count = get_total_count(queryable)

    max_page =
      total_count
      |> (&(&1/per_page)).()
      |> Float.ceil()
      |> trunc()

    %{
      page: Map.get(formated_params, :page),
      per_page: per_page,
      total_count: total_count,
      max_page: max_page
    }
  end

  # 获取搜索对象总数
  defp get_total_count(queryable) do
    queryable
    |> exclude(:select)
    |> exclude(:preload)
    |> exclude(:order_by)
    |> exclude(:limit)
    |> exclude(:offset)
    |> get_count()
  end

  defp get_count(query) do
    query
    |> distinct(:true)
    |> Repo.all()
    |> Enum.count()
  end
end
