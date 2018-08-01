defmodule MiphaWeb.Admin.TopicController do
  use MiphaWeb, :controller

  alias Mipha.Topics.Queries

  def index(conn, params) do
    result = Queries.list_topics() |> Turbo.Ecto.turbo(params)
    render conn, :index, topics: result.datas, paginate: result.paginate
  end
end
