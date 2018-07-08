defmodule MiphaWeb.TopicView do
  use MiphaWeb, :view

  alias Mipha.{Stars, Collections}

  @doc """
  """
  def has_starred?(clauses) do
    Stars.has_starred?(clauses)
  end

  @doc """
  """
  def get_starred_count(clauses) do
    Stars.get_starred_count(clauses)
  end

  @doc """
  """
  def has_collected?(current_user, topic) do
    Collections.has_collected?(user: current_user, topic: topic)
  end
end
