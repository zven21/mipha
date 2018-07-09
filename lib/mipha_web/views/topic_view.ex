defmodule MiphaWeb.TopicView do
  use MiphaWeb, :view

  alias Mipha.{Stars, Collections}

  @doc """
  """
  def has_starred?(clauses) do
    if is_nil(Keyword.get(clauses, :user)), do: false, else: Stars.has_starred?(clauses)
  end

  @doc """
  """
  def get_starred_count(clauses) do
    Stars.get_starred_count(clauses)
  end

  @doc """
  """
  def has_collected?(current_user, topic) do
    if is_nil(current_user),
      do: false,
      else: Collections.has_collected?(user: current_user, topic: topic)
  end
end
