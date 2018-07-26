defmodule MiphaWeb.Plug.RequireAdmin do
  @moduledoc false

  import Plug.Conn
  import Phoenix.Controller

  alias MiphaWeb.Router.Helpers

  def init(opts), do: opts

  def call(conn, _opts) do
    user = conn.assigns[:current_user]

    if user && user.is_admin do
      conn
    else
      conn
      |> put_flash(:danger, "Admin only")
      |> redirect(to: Helpers.page_path(conn, :index))
      |> halt()
    end
  end
end
