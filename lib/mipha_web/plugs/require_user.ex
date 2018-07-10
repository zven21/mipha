defmodule MiphaWeb.Plug.RequireUser do
  @moduledoc """
  A `Plug` to redirect to `pages/index` if there is no current user.
  """

  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  import MiphaWeb.Router.Helpers
  import MiphaWeb.Session, only: [user_logged_in?: 1]

  def init(opts), do: opts

  def call(conn, _opts) do
    if user_logged_in?(conn) do
      conn
    else
      conn
      |> put_flash(:danger, "You must be login in.")
      |> redirect(to: auth_path(conn, :login))
      |> halt()
    end
  end
end
