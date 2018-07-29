defmodule Mipha.Ransack do
  @moduledoc """
  搜索组件，支持搜索、排序、分页功能。
  """

  alias Mipha.Repo
  alias Mipha.Ransack.{Paginate, Sort, Search}

  @doc """
  返回搜索结果和分页信息。

  ## Example

    iex> params = %{"q" => %{"title_like" => "q"}, "s" => "updated_at+asc", "per_page" => 5, "page" => 1}
    iex> Mipha.Ransack.ransack(Mipha.Topics.Topic, params)
    %{
      paginate: %{max_page: 2, page: 1, per_page: 5, total_count: 8},
      result: [Mipha.Topics.Topic]
    }

  """
  @spec ransack(Ecto.Query.t(), Map.t()) :: Map.t()
  def ransack(queryable, params) do
    queryable = ransackq(queryable, params)

    %{
      datas: queryable |> Repo.all(),
      paginate: get_paginate(queryable, params)
    }
  end

  @doc """
  返回搜索组装的 queryable
  """
  @spec ransackq(Ecto.Query.t(), Map.t()) :: Ecto.Query.t()
  def ransackq(queryable, params) do
    [Search, Sort, Paginate]
    |> Enum.reduce(queryable, &run_hook(&1, &2, params))
  end

  @doc """
  返回搜索结果

  ## Example

      iex> search(Mipha.Topics.Topic, %{"q" => %{"title_like" => "q"}})
      [Mipha.Topics.Topic]

  """
  @spec search(Ecto.Query.t(), Map.t()) :: any
  def search(queryable, params), do: Search.run(queryable, params)

  @doc """
  返回拼凑的搜索 queryable.

  ## Example

    iex> searchq(Mipha.Topics.Topic, %{"q" => %{"title_like" => "q"}})
    #Ecto.Query<from t in Mipha.Topics.Topic, where: like(t.title, ^"%q%")>

  """
  @spec search(Ecto.Query.t(), Map.t()) :: Ecto.Query.t()
  def searchq(queryable, params), do: Search.runq(queryable, params)

  @doc """
  返回排序搜索结果
  """
  @spec sort(Ecto.Query.t(), Map.t()) :: any
  def sort(queryable, params), do: Sort.run(queryable, params)

  @doc """
  返回排序 queryable
  params = %{"s" => "email+asc"}
  """
  @spec sortq(Ecto.Query.t(), Map.t()) :: Ecto.Query.t()
  def sortq(queryable, params), do: Sort.runq(queryable, params)

  @doc """
  通过传入的 params, 获取查询结果与 paginate 信息
  params = %{"per_page" => 5, "page" => 2}
  """
  @spec paginate(Ecto.Query.t(), Map.t()) :: Map.t()
  def paginate(queryable, params), do: Paginate.run(queryable, params)

  @doc """
  通过传入的 params, 获取拼凑的 queryable

  ## Example

      iex> params = %{"per_page" => 5, "page" => 2}
      iex> Mipha.Ransack.paginateq(Mipha.Topics.Topic, params)
      #Ecto.Query<from t in Mipha.Topics.Topic, limit: ^5, offset: ^5>

  """
  @spec paginateq(Ecto.Query.t(), Map.t()) :: Ecto.Query.t()
  def paginateq(queryable, params), do: Paginate.runq(queryable, params)

  @doc """
  获取分页信息

  ## Example

      iex> get_paginate(queryable, params)
      %{max_page: 1, page: 2, per_page: 5, total_count: 1}

  """
  @spec get_paginate(Ecto.Query.t(), Map.t()) :: Map.t()
  def get_paginate(queryable, params), do: Paginate.get_paginate(queryable, params)

  # 调用各方法的 runq
  defp run_hook(hook, queryable, params), do: apply(hook, :runq, [queryable, params])
end
