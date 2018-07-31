defmodule MiphaWeb.SearchController do
  use MiphaWeb, :controller

  alias Mipha.{Accounts, Qiniu}

  def index(conn, _) do
    render conn, :index
  end

  @doc """
  Filters the mention users.
  """
  def users(conn, params) do
    users =
      conn
      |> current_user()
      |> Accounts.search_mention_user(params["q"])
      |> Enum.map(&(%{login: &1.username, avatar_url: Qiniu.q_url(&1.avatar)}))

    json(conn, users)
  end
end
