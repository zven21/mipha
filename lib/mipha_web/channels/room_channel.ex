defmodule MiphaWeb.RoomChannel do
  @moduledoc """
  Room Channel
  """

  use MiphaWeb, :channel

  alias MiphaWeb.Presence
  alias Mipha.Repo
  alias Mipha.Accounts.User

  def join("room:lobby", payload, socket) do
    if authorized?(payload) do
      send(self(), :after_join)
      {:ok, %{channel: "room:lobby"}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    push socket, "presence_state", Presence.list(socket)

    user = Repo.get(User, socket.assigns[:user_id])

    {:ok, _} = Presence.track(socket, "user:#{user.id}", %{
      user_id: user.id,
      username: user.username
    })

    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
