defmodule MiphaWeb.Admin.ReplyController do
  use MiphaWeb, :controller

  alias Mipha.Replies
  alias Mipha.Replies.Reply

  def index(conn, _params) do
    repies = Replies.list_repies()
    render(conn, "index.html", repies: repies)
  end

  def new(conn, _params) do
    changeset = Replies.change_reply(%Reply{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"reply" => reply_params}) do
    case Replies.create_reply(reply_params) do
      {:ok, reply} ->
        conn
        |> put_flash(:info, "Reply created successfully.")
        |> redirect(to: admin_reply_path(conn, :show, reply))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    reply = Replies.get_reply!(id)
    render(conn, "show.html", reply: reply)
  end

  def edit(conn, %{"id" => id}) do
    reply = Replies.get_reply!(id)
    changeset = Replies.change_reply(reply)
    render(conn, "edit.html", reply: reply, changeset: changeset)
  end

  def update(conn, %{"id" => id, "reply" => reply_params}) do
    reply = Replies.get_reply!(id)

    case Replies.update_reply(reply, reply_params) do
      {:ok, reply} ->
        conn
        |> put_flash(:info, "Reply updated successfully.")
        |> redirect(to: admin_reply_path(conn, :show, reply))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", reply: reply, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    reply = Replies.get_reply!(id)
    {:ok, _reply} = Replies.delete_reply(reply)

    conn
    |> put_flash(:info, "Reply deleted successfully.")
    |> redirect(to: admin_reply_path(conn, :index))
  end
end
