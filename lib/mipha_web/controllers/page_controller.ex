defmodule MiphaWeb.PageController do
  use MiphaWeb, :controller

  alias Mipha.Markdown

  def index(conn, _params) do
    render conn, :index
  end

  def markdown(conn, _) do
    markdown_ex = Markdown.example
    render conn, :markdown, markdown_ex: markdown_ex
  end
end
