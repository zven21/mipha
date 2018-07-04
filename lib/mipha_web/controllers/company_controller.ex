defmodule MiphaWeb.CompanyController do
  use MiphaWeb, :controller

  def action(conn, _) do
    render conn, action_name(conn)
  end
end
