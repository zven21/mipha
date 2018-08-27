defmodule MiphaWeb.RoomChannel do
  @moduledoc false

  use MiphaWeb, :channel

  alias MiphaWeb.Presence
  alias Mipha.Repo
  alias Mipha.Accounts.User

  def join(channel_name, _params, socket) do
    send(self(), :after_join)
    {:ok, %{channel: channel_name}, socket}
  end

  def handle_info(:after_join, socket) do
    push socket, "presence_state", Presence.list(socket)

    user = Repo.get(User, socket.assigns[:user])

    {:ok, _} = Presence.track(socket, "user:#{user.id}", %{
      user_id: user.id,
      username: user.username
    })

    {:noreply, socket}
  end
end
