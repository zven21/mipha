defmodule MiphaWeb.TopicView do
  use MiphaWeb, :view

  alias Mipha.{Stars, Collections}

  @doc """
  """
  def has_starred?(current_user, topic), do: Stars.has_starred?(user: current_user, topic: topic)

  @doc """
  """
  def get_star_topic_count(topic), do: Stars.get_starred_count(topic: topic)

  @doc """
  """
  def get_star_reply_count(reply), do: Stars.get_starred_count(reply: reply)

  @doc """
  """
  def has_collected?(current_user, topic) do
    Collections.has_collected?(user: current_user, topic: topic)
  end
end
