defmodule MiphaWeb.TeamController do
  use MiphaWeb, :controller

  alias Mipha.{Repo, Accounts, Topics}

  def index(conn, _params) do
    render conn, :index
  end

  def show(conn, %{"id" => id}) do
    team = Accounts.get_team!(id)
    team_user_ids = Enum.map(team.users, &(&1.id))

    page =
      [user_ids: team_user_ids]
      |> Topics.cond_topics
      |> Repo.paginate(conn.params)

    render conn, :show,
      team: team,
      topics: page.entries,
      page: page
  end

  def people(conn, %{"id" => id}) do
    team = Accounts.get_team!(id)
    render conn, :people, team: team
  end
end
