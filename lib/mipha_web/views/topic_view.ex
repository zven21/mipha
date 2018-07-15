defmodule MiphaWeb.TopicView do
  use MiphaWeb, :view

  alias Mipha.{Stars, Collections}

  @doc """
  判断是否已 Star
  """
  def has_starred?(clauses) do
    if is_nil(Keyword.get(clauses, :user)), do: false, else: Stars.has_starred?(clauses)
  end

  @doc """
  获取 Star 个数

  ## Example

      iex> get_starred_count(topic: topic)
      10

      iex> get_starred_count(reply: reply)
      20

  """
  def get_starred_count(clauses) do
    Stars.get_starred_count(clauses)
  end

  @doc """
  判断是否已收藏该帖。
  """
  def has_collected?(current_user, topic) do
    if is_nil(current_user),
      do: false,
      else: Collections.has_collected?(user: current_user, topic: topic)
  end
end
