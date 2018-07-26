defmodule MiphaWeb.Admin.TeamController do
  use MiphaWeb, :controller

  alias Mipha.Accounts

  def index(conn, _params) do
    teams = Accounts.list_teams()
    render(conn, "index.html", teams: teams)
  end

  def delete(conn, %{"id" => id}) do
    team = Accounts.get_team!(id)
    {:ok, _team} = Accounts.delete_team(team)

    conn
    |> put_flash(:info, "Team deleted successfully.")
    |> redirect(to: admin_team_path(conn, :index))
  end
end
