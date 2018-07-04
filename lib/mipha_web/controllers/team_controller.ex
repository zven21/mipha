defmodule MiphaWeb.TeamController do
  use MiphaWeb, :controller

  alias Mipha.Accounts

  def index(conn, _params) do
    render conn, :index
  end

  def show(conn, %{"id" => id}) do
    team = Accounts.get_team!(id)
    render conn, :show, team: team
  end
end
