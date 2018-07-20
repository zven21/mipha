defmodule MiphaWeb.PersonController do
  use MiphaWeb, :controller

  alias Mipha.Accounts

  plug MiphaWeb.Plug.RequireUser when action in [:new, :edit, :create, :udpate, :delete]

  def action(conn, _) do
    if conn.params["slug"] do
      team = Accounts.get_team_by_slug(conn.params["slug"])
      apply(__MODULE__, action_name(conn), [conn, conn.params, team])
    else
      apply(__MODULE__, action_name(conn), [conn, conn.params])
    end
  end

  def index(conn, _params, team) do
    render conn, :index, team: team
  end

  # def show(conn, _params, team) do
  # end

  # def edit(conn, _params, team) do
  # end

  # def create(conn, _params, team) do
  # end

  # def update(conn, %{"name" => name}, team) do
  # end

  # def delete(conn, %{"name" => name}, team) do
  # end

  # def set_accept(conn, _params, team) do
  # end

  # def set_reject(conn, _params, team) do
  # end

  # def transfer_owner(conn, _params, team) do
  # end
end
