defmodule MiphaWeb.TeamController do
  use MiphaWeb, :controller

  alias Mipha.{Repo, Accounts, Topics}
  alias Accounts.Team
  alias Mipha.Qiniu

  plug MiphaWeb.Plug.RequireUser when action in [:new, :edit, :create, :udpate]

  def action(conn, _) do
    if conn.params["slug"] do
      team = Accounts.get_team_by_slug(conn.params["slug"])
      apply(__MODULE__, action_name(conn), [conn, conn.params, team])
    else
      apply(__MODULE__, action_name(conn), [conn, conn.params])
    end
  end

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
        |> put_flash(:success, "团队创建成功。")
        |> redirect(to: team_path(conn, :edit, team.slug))

      {:error, %Ecto.Changeset{} = changeset} ->
        render conn, :new, changeset: changeset
    end
  end

  def update(conn, %{"team" => team_params}, team) do
    attrs =
      team_params
      |> Map.pop("avatar")
      |> build_attrs

    case Accounts.update_team(team, attrs) do
      {:ok, team} ->
        conn
        |> put_flash(:success, "团队修改成功。")
        |> redirect(to: team_path(conn, :show, team.slug))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:danger, "团队修改失败。")
        |> render(:edit, team: team, changeset: changeset)
    end
  end

  def edit(conn, _params, team) do
    if current_user(conn).id != team.owner_id do
      conn
      |> put_flash(:danger, "你没有权限修改该团队。")
      |> redirect(to: team_path(conn, :show, team.slug))
    end

    changeset = Accounts.change_team(team)
    render conn, :edit, changeset: changeset, team: team
  end

  def show(conn, _params, team) do
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

  def people(conn, _params, team) do
    render conn, :people, team: team
  end

  # 构建 params
  defp build_attrs({nil, params}), do: params
  defp build_attrs({%Plug.Upload{} = avatar, params}) do
    with %HTTPoison.Response{status_code: 200, body: body} <- Qiniu.upload(avatar.path) do
      Map.merge(params, %{"avatar" => body["key"]})
    end
  end
end
