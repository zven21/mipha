defmodule MiphaWeb.ViewHelpers do
  @moduledoc """
  View helpers for global funcs we find useful.
  """
  import Phoenix.HTML, only: [raw: 1]
  alias Mipha.Markdown

  def markdown(body) do
    body
    |> Markdown.render
    |> raw()
  end
end
