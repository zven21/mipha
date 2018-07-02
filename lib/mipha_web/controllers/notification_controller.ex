defmodule MiphaWeb.NotificationController do
  use MiphaWeb, :controller

  @intercepted_action ~w(index)a

  def action(conn, _) do
    if Enum.member?(@intercepted_action, action_name(conn)) do
      render conn, action_name(conn)
    end
  end
end
