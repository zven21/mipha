defmodule MiphaWeb.TopicChannel do
  @moduledoc false

  use MiphaWeb, :channel

  def join("topic:" <> topic_id, _params, socket) do
    {:ok, %{channel: "topic:#{topic_id}"}, assign(socket, :topic_id, topic_id)}
  end
end
