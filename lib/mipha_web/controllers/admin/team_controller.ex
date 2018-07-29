defmodule MiphaWeb.Admin.TeamController do
  use MiphaWeb, :controller

  alias Mipha.Accounts
  alias Mipha.Accounts.Team
  alias Mipha.Ransack

  def index(conn, params) do
    result = Ransack.ransack(Team, params)
    render conn, :index, teams: result.datas, paginate: result.paginate
  end

  def delete(conn, %{"id" => id}) do
    team = Accounts.get_team!(id)
    {:ok, _team} = Accounts.delete_team(team)

    conn
    |> put_flash(:info, "Team deleted successfully.")
    |> redirect(to: admin_team_path(conn, :index))
  end
end
