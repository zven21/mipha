defmodule MiphaWeb.Admin.ReplyController do
  use MiphaWeb, :controller

  alias Mipha.Replies

  def index(conn, _params) do
    repies = Replies.list_repies()
    render(conn, "index.html", repies: repies)
  end

  def show(conn, %{"id" => id}) do
    reply = Replies.get_reply!(id)
    render(conn, "show.html", reply: reply)
  end

  def delete(conn, %{"id" => id}) do
    reply = Replies.get_reply!(id)
    {:ok, _reply} = Replies.delete_reply(reply)

    conn
    |> put_flash(:info, "Reply deleted successfully.")
    |> redirect(to: admin_reply_path(conn, :index))
  end
end
