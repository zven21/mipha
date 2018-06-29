defmodule MiphaWeb.PageController do
  use MiphaWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
