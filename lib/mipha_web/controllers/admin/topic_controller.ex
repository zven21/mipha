defmodule MiphaWeb.Admin.TopicController do
  use MiphaWeb, :controller

  alias Mipha.Topics.Queries

  def index(conn, params) do
    result = Queries.topics(params)
    render conn, :index, topics: result.datas, paginate: result.paginate
  end
end
