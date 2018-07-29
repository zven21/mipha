defmodule Mipha.Ransack.Services.BuildSearchQuery do
  @moduledoc false

  import Ecto.Query

  @type search_expr :: :where | :or_where | :not_where
  @type search_type :: :like | :ilike | :eq | :gt
                  | :lt | :gteq | :lteq | :is_null

  @search_types ~w(like ilike eq gt lt gteq lteq is_null)a
  @search_exprs ~w(where or_where not_where)a

  def run(queryable, field, {search_expr, search_type}, search_term) when search_type in @search_types and search_expr in @search_exprs do
    apply(__MODULE__, String.to_atom("handle_" <> to_string(search_type)),
          [queryable, field, search_term, search_expr])
  end

  def run(_, _, search_tuple, _) do
    raise "Unknown {search_expr, search_type}, #{inspect search_tuple}\n" <>
      "search_type should be one of #{inspect @search_types}\n" <>
      "search_expr should be one of #{inspect @search_exprs}"
  end

  @spec handle_like(Ecto.Query.t(), atom(), String.t(),
                    __MODULE__.search_expr()) :: Ecto.Query.t()
  def handle_like(queryable, field, search_term, :where) do
    queryable
    |> where([..., b],
      like(field(b, ^field), ^"%#{String.replace(search_term, "%", "\\%")}%"))
  end
  def handle_like(queryable, field, search_term, :or_where) do
    queryable
    |> or_where([..., b],
      like(field(b, ^field), ^"%#{String.replace(search_term, "%", "\\%")}%"))
  end
  def handle_like(queryable, field, search_term, :not_where) do
    queryable
    |> where([..., b],
      not like(field(b, ^field), ^"%#{String.replace(search_term, "%", "\\%")}%"))
  end

  @doc """
  """
  @spec handle_ilike(Ecto.Query.t(), atom(), String.t(),
                    __MODULE__.search_expr()) :: Ecto.Query.t()
  def handle_ilike(queryable, field, search_term, :where) do
    queryable
    |> where([..., b],
      ilike(field(b, ^field), ^"%#{String.replace(search_term, "%", "\\%")}%"))
  end
  def handle_ilike(queryable, field, search_term, :or_where) do
    queryable
    |> or_where([..., b],
      ilike(field(b, ^field), ^"%#{String.replace(search_term, "%", "\\%")}%"))
  end
  def handle_ilike(queryable, field, search_term, :not_where) do
    queryable
    |> where([..., b],
      not ilike(field(b, ^field), ^"%#{String.replace(search_term, "%", "\\%")}%"))
  end

  @doc """
  """
  @spec handle_eq(Ecto.Query.t(), atom(), term(),
                  __MODULE__.search_expr()) :: Ecto.Query.t()
  def handle_eq(queryable, field, search_term, :where) do
    queryable
    |> where([..., b],
      field(b, ^field) == ^search_term)
  end
  def handle_eq(queryable, field, search_term, :or_where) do
    queryable
    |> or_where([..., b],
      field(b, ^field) == ^search_term)
  end
  def handle_eq(queryable, field, search_term, :not_where) do
    queryable
    |> where([..., b],
      field(b, ^field) != ^search_term)
  end

  @doc """
  """
  @spec handle_gt(Ecto.Query.t(), atom(), term(),
                  __MODULE__.search_expr()) :: Ecto.Query.t()
  def handle_gt(queryable, field, search_term, :where) do
    queryable
    |> where([..., b],
      field(b, ^field) > ^search_term)
  end
  def handle_gt(queryable, field, search_term, :or_where) do
    queryable
    |> or_where([..., b],
      field(b, ^field) > ^search_term)
  end
  def handle_gt(queryable, field, search_term, :not_where) do
    queryable
    |> where([..., b],
      field(b, ^field) <= ^search_term)
  end

  @doc """
  """
  @spec handle_lt(Ecto.Query.t(), atom(), term(),
                  __MODULE__.search_expr()) :: Ecto.Query.t()
  def handle_lt(queryable, field, search_term, :where) do
    queryable
    |> where([..., b],
      field(b, ^field) < ^search_term)
  end
  def handle_lt(queryable, field, search_term, :or_where) do
    queryable
    |> or_where([..., b],
      field(b, ^field) < ^search_term)
  end
  def handle_lt(queryable, field, search_term, :not_where) do
    queryable
    |> where([..., b],
      field(b, ^field) >= ^search_term)
  end

  @doc """
  """
  @spec handle_gteq(Ecto.Query.t(), atom(), term(),
                    __MODULE__.search_expr()) :: Ecto.Query.t()
  def handle_gteq(queryable, field, search_term, :where) do
    queryable
    |> where([..., b],
      field(b, ^field) >= ^search_term)
  end
  def handle_gteq(queryable, field, search_term, :or_where) do
    queryable
    |> or_where([..., b],
      field(b, ^field) >= ^search_term)
  end
  def handle_gteq(queryable, field, search_term, :not_where) do
    queryable
    |> where([..., b],
      field(b, ^field) < ^search_term)
  end

  @doc """
  """
  @spec handle_lteq(Ecto.Query.t(), atom(), term(),
                    __MODULE__.search_expr()) :: Ecto.Query.t()
  def handle_lteq(queryable, field, search_term, :where) do
    queryable
    |> where([..., b],
      field(b, ^field) <= ^search_term)
  end
  def handle_lteq(queryable, field, search_term, :or_where) do
    queryable
    |> or_where([..., b],
      field(b, ^field) <= ^search_term)
  end
  def handle_lteq(queryable, field, search_term, :not_where) do
    queryable
    |> where([..., b],
      field(b, ^field) > ^search_term)
  end

  @doc """
  """
  @spec handle_is_null(Ecto.Query.t(), atom(), boolean(),
                      __MODULE__.search_expr()) :: Ecto.Query.t()
  def handle_is_null(queryable, field, true, :where)do
    queryable
    |> where([..., b],
      is_nil(field(b, ^field)))
  end
  def handle_is_null(queryable, field, true, :or_where)do
    queryable
    |> or_where([..., b],
      is_nil(field(b, ^field)))
  end
  def handle_is_null(queryable, field, true, :not_where)do
    queryable
    |> where([..., b],
      not is_nil(field(b, ^field)))
  end
  def handle_is_null(queryable, field, :false, :where) do
    queryable
    |> where([..., b],
      not is_nil(field(b, ^field)))
  end
  def handle_is_null(queryable, field, :false, :or_where) do
    queryable
    |> or_where([..., b],
      not is_nil(field(b, ^field)))
  end
  def handle_is_null(queryable, field, :false, :not_where) do
    queryable
    |> where([..., b],
      is_nil(field(b, ^field)))
  end
end
