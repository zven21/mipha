defmodule Mipha.Factory do
  @moduledoc """
  ExMachina Factory funcs to use in tests.

  ## Examples

      iex> Factory.insert(:topic)
      %Topic{}

  """

  use ExMachina.Ecto, repo: Mipha.Repo

  alias Mipha.Accounts.{User, Company, Team}
  alias Mipha.Topics.{Topic, Node}
  alias Mipha.Replies.Reply
  alias Mipha.Collections.Collection
  alias Mipha.Notifications.{Notification, UserNotification}
  alias Mipha.Stars.Star
  alias Mipha.Follows.Follow

  @spec user_factory :: User.t()
  def user_factory do
    %User{
      username: sequence(:username, &"user#{&1}"),
      email: sequence(:email, &"user#{&1}@elixir-mipha.com"),
      is_admin: false
    }
  end

  @spec topic_factory :: Topic.t()
  def topic_factory do
    %Topic{
      user: build(:user),
      node: build(:node),
      title: sequence(:title, &"topic-title#{&1}"),
      body: sequence(:body, &"topic-body#{&1}")
    }
  end

  @spec node_factory :: Node.t()
  def node_factory do
    %Node{
      name: sequence(:name, &"node-name#{&1}")
    }
  end

  @spec reply_factory :: Reply.t()
  def reply_factory do
    %Reply{
      content: sequence(:content, &"reply-content#{&1}"),
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
      follower: build(:user),
      user: build(:user)
    }
  end

  @spec company_factory :: Company.t()
  def company_factory do
    %Company{
      name: sequence(:name, &"company-name#{&1}")
    }
  end

  @spec team_factory :: Team.t()
  def team_factory do
    %Team{
      name: sequence(:name, &"team-name#{&1}"),
      owner: build(:user)
    }
  end
end
