defmodule MiphaWeb.PageController do
  use MiphaWeb, :controller

  alias Mipha.{
    Topics,
    Accounts
  }

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

  def markdown(conn, _) do
    render conn, :markdown
  end

  def about(conn, _) do
    render conn, :about
  end
end
