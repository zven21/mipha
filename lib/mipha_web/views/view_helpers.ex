defmodule MiphaWeb.ViewHelpers do
  @moduledoc """
  View helpers for global funcs we find useful.
  """

  import Phoenix.HTML, only: [raw: 1]
  alias Mipha.Markdown

  def markdown(body) do
    body
    |> Markdown.render
    |> raw
  end

  @doc """
  装饰 paginate 参数，添加 params 和 path_info
  """
  def decorator_paginate(conn, paginate) do
    Map.merge(paginate, %{path_info: conn.path_info, params: conn.params})
  end
end
