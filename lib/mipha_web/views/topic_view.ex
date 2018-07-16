defmodule MiphaWeb.TopicView do
  use MiphaWeb, :view

  alias Mipha.{
    Stars,
    Collections,
    Topics,
    Accounts,
    Replies
  }

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

  @doc """
  获取全站 topic 个数
  """
  def get_topic_count do
    Topics.get_total_topic_count()
  end

  @doc """
  获取全站 topic 个数
  """
  def get_reply_count do
    Replies.get_total_reply_count()
  end

  @doc """
  获取全站 user 个数
  """
  def get_user_count do
    Accounts.get_total_user_count()
  end
end
