defmodule MiphaWeb.PageController do
  use MiphaWeb, :controller

  alias Mipha.{Topics, Accounts, Markdown}

  def index(conn, _params) do
    parent_nodes = Topics.list_parent_nodes
    locations = Accounts.list_locations
    topics = Topics.list_featured_topics

    render conn, :index,
      topics: topics,
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
