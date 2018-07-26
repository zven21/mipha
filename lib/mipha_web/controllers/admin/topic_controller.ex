defmodule MiphaWeb.Admin.TopicController do
  use MiphaWeb, :controller

  alias Mipha.Topics

  def index(conn, _params) do
    topics = Topics.list_topics()
    render(conn, "index.html", topics: topics)
  end
end
