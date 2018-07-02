defmodule MiphaWeb.Admin.PageController do
  use MiphaWeb, :controller

  def index(conn, _) do
    render conn, :index
  end
end
