defmodule MiphaWeb.TeamController do
  use MiphaWeb, :controller

  alias Mipha.{Repo, Accounts, Topics}
  alias Accounts.Team

  def index(conn, _params) do
    render conn, :index
  end

  def new(conn, _params) do
    changeset = Accounts.change_team(%Team{})
    render conn, :new, changeset: changeset
  end

  def create(conn, %{"team" => team_params}) do
    case Accounts.insert_team(current_user(conn), team_params) do
      {:ok, team} ->
        conn
        |> put_flash(:success, "组织创建成功")
        |> redirect(to: team_path(conn, :show, team))

      {:error, %Ecto.Changeset{} = changeset} ->
        render conn, :new, changeset: changeset
    end
  end

  def edit(conn, _params) do
    render conn, :edit
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
