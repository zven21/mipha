defmodule MiphaWeb.TopicController do
  use MiphaWeb, :controller

  @intercepted_action ~w(index show)a

  def action(conn, _) do
    if Enum.member?(@intercepted_action, action_name(conn)) do
      render conn, action_name(conn)
    end
  end
end
