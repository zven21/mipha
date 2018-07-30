defmodule Trubo.HTML.Form do
  @moduledoc """
  搜索 form 装饰器
  """

  use Phoenix.HTML

  def trubo_search_input(conn, field, opts \\ []) do
    value =
      conn.params
      |> Plug.Conn.Query.encode()
      |> String.split(field <> "=")
      |> tl()
      |> Enum.at(0)

    content_tag(:input, "",
      name: field, value: value,
      class: Keyword.get(opts, :class),
      placeholder: Keyword.get(opts, :placeholder)
    )
  end
end
