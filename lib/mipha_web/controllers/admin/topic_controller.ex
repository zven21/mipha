defmodule MiphaWeb.Admin.TopicController do
  use MiphaWeb, :controller

  alias Mipha.Topics
  alias Mipha.Topics.Topic
  alias Mipha.Ransack

  def index(conn, params) do
    result = Ransack.ransack(Topic, params)
    render conn, :index, topics: result.datas, paginate: result.paginate
  end
end
