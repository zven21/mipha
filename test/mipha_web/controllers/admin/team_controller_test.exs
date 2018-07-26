defmodule MiphaWeb.Admin.TeamControllerTest do
  use MiphaWeb.ConnCase

  alias Mipha.Accounts

  @create_attrs %{
    avatar: "some avatar",
    github_handle: "some github_handle",
    name: "some name",
    owner_id: 42,
    summary: "some summary"
  }

  def fixture(:team) do
    {:ok, team} = Accounts.create_team(@create_attrs)
    team
  end

  describe "index" do
    test "lists all teams", %{conn: conn} do
      conn = get conn, admin_team_path(conn, :index)
      assert html_response(conn, 200) =~ "#"
    end
  end

  describe "delete team" do
    setup [:create_team]

    test "deletes chosen team", %{conn: conn, team: team} do
      conn = delete conn, admin_team_path(conn, :delete, team)
      assert redirected_to(conn) == admin_team_path(conn, :index)
    end
  end

  defp create_team(_) do
    team = fixture(:team)
    {:ok, team: team}
  end
end
