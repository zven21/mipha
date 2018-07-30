defmodule Trubo.HTML do
  @moduledoc false

  alias Trubo.HTML.{Form, Paginate}

  @doc """
  paginate View
  """
  def trubo_pagination_links(paginator) do
    Paginate.quest_pagination_links(paginator)
  end

  @doc """
  decorator paginate params.
  """
  def decorator_paginate(conn, paginate) do
    Map.merge(paginate, %{path_info: conn.path_info, params: conn.params})
  end

  @doc """
  decorator input view.
  """
  def trubo_search_input(conn, field, opts) do
    Form.trubo_search_input(conn, field, opts)
  end
end
