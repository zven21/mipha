defmodule MiphaWeb.UserView do
  use MiphaWeb, :view

  alias Mipha.{
    Accounts,
    Topics,
    Replies,
    Follows,
    Collections
  }

  def format_inserted_date(datetime) do
    Timex.format!(datetime, "{YYYY}-{0M}-{0D}")
  end

  def user_topics_count(user) do
    Topics.get_topic_count(user)
  end

  def user_replies_count(user) do
    Replies.get_reply_count(user: user)
  end

  def user_followers_count(user) do
    Follows.get_follower_count(user: user)
  end

  def user_following_count(user) do
    Follows.get_followee_count(user)
  end

  def user_collections_count(user) do
    Collections.get_collection_count(user)
  end

  @doc """
  Returen `true` if the current_user followed target_user, `false` otherwise.
  """
  def has_followed?(current_user, user) do
    Follows.has_followed?(follower: current_user, user: user)
  end

  def github_repos(target) do
    Accounts.github_repositories(target)
  end

  def github_account(target) do
    Accounts.github_handle(target)
  end
end
