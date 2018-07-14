defmodule MiphaWeb.PageController do
  use MiphaWeb, :controller

  alias Mipha.{Topics, Accounts, Markdown}

  def index(conn, _params) do
    parent_nodes = Topics.list_parent_nodes
    locations = Accounts.list_locations

    {odd, even} =
      Topics.list_featured_topics
      |> Enum.with_index
      |> Enum.split_with(fn {_, i} -> rem(i, 2) == 0 end)

    render conn, :index,
      odd_topics: odd,
      even_topics: even,
      parent_nodes: parent_nodes,
      locations: locations
  end

  def search(conn, _params) do
    render conn, :search
  end

  def markdown(conn, _) do
    markdown_ex = Markdown.example
    render conn, :markdown,
      markdown_ex: markdown_ex
  end
end
