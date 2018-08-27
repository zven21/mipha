defmodule MiphaWeb.Plug.CurrentUser do
  @moduledoc """
  A `Plug` to assign `:current_user` && `:user_token` based on the session
  """

  import Plug.Conn
  import MiphaWeb.Session, only: [current_user: 1, user_token: 1]

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> assign(:current_user, current_user(conn))
    |> assign(:user_token, user_token(conn))
  end
end
