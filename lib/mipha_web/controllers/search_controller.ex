defmodule MiphaWeb.SearchController do
  use MiphaWeb, :controller

  alias Mipha.Accounts
  alias Mipha.Qiniu

  def index(conn, _) do
    render conn, :index
  end

  def users(conn, _) do
    # FIXME 只能只能匹配到关注用户，或该帖子已评论的用户
    users = Accounts.list_users
    json(conn, Enum.map(users, fn(u) -> %{login: u.username, avatar_url: Qiniu.q_url(u.avatar)} end))
  end
end
