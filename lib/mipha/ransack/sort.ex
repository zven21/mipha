defmodule Mipha.Ransack.Sort do
  @moduledoc """
  Single Table Sort
  """

  import Ecto.Query
  alias Mipha.Repo
  alias Mipha.Ransack.Utils

  @sort_order ~w(asc desc)a

  @doc """
  """
  @spec run(Ecto.Query.t(), Map.t()) :: any()
  def run(queryable, params) do
    queryable
    |> runq(params)
    |> Repo.all()
  end

  @doc """
  params = %{"s" => "email+asc"}
  %{assoc: [], field: :email, order: :asc}
  可以考虑暂时只支持单表处理，然后支持多表查询
  """
  def runq(queryable, params), do: handle_sort(queryable, params)

  defp handle_sort(queryable, sort_params) do
    sort_params
    |> Map.get("s", "")
    |> String.split("+")
    |> build_sort(queryable)
  end

  defp handle_ordering(queryable, field, order) do
    order_by_assoc(queryable, order, field)
  end

  defp order_by_assoc(queryable, order_type, field) do
    order_by(queryable, [p0, ..., p2], [{^order_type, field(p2, ^field)}])
  end

  defp build_sort([field, order] = sort_string, queryable) when length(sort_string) == 2 do
    field = String.to_atom(field)
    order = String.to_atom(order)
    queryable = Utils.schema_from_query(queryable)

    if field in queryable.__schema__(:fields) && order in @sort_order do
      handle_ordering(queryable, field, order)
    else
      queryable
    end
  end
  defp build_sort(_, queryable), do: queryable
end
