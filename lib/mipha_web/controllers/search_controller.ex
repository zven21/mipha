defmodule MiphaWeb.SearchController do
  use MiphaWeb, :controller

  alias Mipha.{Accounts, Qiniu}

  def index(conn, _) do
    render conn, :index
  end

  def users(conn, params) do
    # 匹配已关注用户
    users =
      current_user(conn)
      |> Accounts.search_mention_user(params["q"])
      |> Enum.map(&(%{login: &1.username, avatar_url: Qiniu.q_url(&1.avatar)}))

    json(conn, users)
  end
end
