defmodule MiphaWeb.SettingController do
  use MiphaWeb, :controller
  alias Mipha.Accounts
  alias Mipha.Accounts.User

  plug MiphaWeb.Plug.RequireUser

  @intercepted_action ~w(show account password profile reward)a

  def action(conn, _) do
    if Enum.member?(@intercepted_action, action_name(conn)) do
      changeset = Accounts.change_user(current_user(conn))
      render conn, action_name(conn), changeset: changeset
    else
      apply(__MODULE__, action_name(conn), [conn, conn.params])
    end
  end
end
