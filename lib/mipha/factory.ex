defmodule Mipha.Factory do
  @moduledoc """
  ExMachina Factory funcs to use in tests.

  ## Examples

      iex> Factory.insert(:topic)
      %Topic{}

  """

  use ExMachina.Ecto, repo: Mipha.Repo

  alias Mipha.Accounts.User
  alias Mipha.Topics.Topic
  alias Mipha.Replies.Reply
  alias Mipha.Collections.Collection
  alias Mipha.Notifications.{Notification, UserNotification}
  alias Mipha.Stars.Star
  alias Mipha.Follows.Follow

  @spec user_factory :: User.t()
  def user_factory do
    %User{
      username: sequence(:username, &"user#{&1}"),
      email: sequence(:email, &"user#{&1}@elixir-mipha.com")
    }
  end

  @spec topic_factory :: Topic.t()
  def topic_factory do
    %Topic{
      user: build(:user),
      title: "elixir-mipha-title",
      body: "elixir-mipha-body"
    }
  end

  @spec reply_factory :: Reply.t()
  def reply_factory do
    %Reply{
      content: "elixir-mipha-reply",
      user: build(:user),
      topic: build(:topic)
    }
  end

  @spec collection_factory :: Collection.t()
  def collection_factory do
    %Collection{
      topic: build(:topic),
      user: build(:user)
    }
  end

  @spec notification_factory :: Notification.t()
  def notification_factory do
    %Notification{
      actor: build(:user),
      action: :followed
    }
  end

  @spec user_notification_factory :: UserNotification.t()
  def user_notification_factory do
    %UserNotification{
      user: build(:user),
      notification: build(:notification)
    }
  end

  @spec star_factory :: Star.t()
  def star_factory do
    %Star{
      user: build(:user)
    }
  end

  @spec follow_factory :: Follow.t()
  def follow_factory do
    %Follow{
      follower: build(:user)
    }
  end
end
