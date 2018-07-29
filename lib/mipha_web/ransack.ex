defmodule MiphaWeb.Ransack do
  @moduledoc false

  alias MiphaWeb.Ransack.{Form, Paginate}

  @doc """
  Ransack 的分页 View
  """
  def ransack_pagination_links(paginator) do
    Paginate.ransack_pagination_links(paginator)
  end

  @doc """
  装饰 paginate 参数，添加 params 和 path_info
  """
  def decorator_paginate(conn, paginate) do
    Map.merge(paginate, %{path_info: conn.path_info, params: conn.params})
  end

  @doc """
  搜索 Input 装饰器
  """
  def ransack_search_input(conn, field, opts) do
    Form.ransack_search_input(conn, field, opts)
  end
end
