defmodule Mipha.NotificationsTest do
  use Mipha.DataCase

  alias Mipha.Notifications

  describe "notifications" do
    alias Mipha.Notifications.Notification

    @valid_attrs %{action: "some action", actor_id: 42, reply_id: 42, topic_id: 42, user_id: 42}
    @update_attrs %{action: "some updated action", actor_id: 43, reply_id: 43, topic_id: 43, user_id: 43}
    @invalid_attrs %{action: nil, actor_id: nil, reply_id: nil, topic_id: nil, user_id: nil}

    def notification_fixture(attrs \\ %{}) do
      {:ok, notification} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Notifications.create_notification()

      notification
    end

    test "list_notifications/0 returns all notifications" do
      notification = notification_fixture()
      assert Notifications.list_notifications() == [notification]
    end

    test "get_notification!/1 returns the notification with given id" do
      notification = notification_fixture()
      assert Notifications.get_notification!(notification.id) == notification
    end

    test "create_notification/1 with valid data creates a notification" do
      assert {:ok, %Notification{} = notification} = Notifications.create_notification(@valid_attrs)
      assert notification.action == "some action"
      assert notification.actor_id == 42
      assert notification.reply_id == 42
      assert notification.topic_id == 42
      assert notification.user_id == 42
    end

    test "create_notification/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Notifications.create_notification(@invalid_attrs)
    end

    test "update_notification/2 with valid data updates the notification" do
      notification = notification_fixture()
      assert {:ok, notification} = Notifications.update_notification(notification, @update_attrs)
      assert %Notification{} = notification
      assert notification.action == "some updated action"
      assert notification.actor_id == 43
      assert notification.reply_id == 43
      assert notification.topic_id == 43
      assert notification.user_id == 43
    end

    test "update_notification/2 with invalid data returns error changeset" do
      notification = notification_fixture()
      assert {:error, %Ecto.Changeset{}} = Notifications.update_notification(notification, @invalid_attrs)
      assert notification == Notifications.get_notification!(notification.id)
    end

    test "delete_notification/1 deletes the notification" do
      notification = notification_fixture()
      assert {:ok, %Notification{}} = Notifications.delete_notification(notification)
      assert_raise Ecto.NoResultsError, fn -> Notifications.get_notification!(notification.id) end
    end

    test "change_notification/1 returns a notification changeset" do
      notification = notification_fixture()
      assert %Ecto.Changeset{} = Notifications.change_notification(notification)
    end
  end

  describe "users_notifications" do
    alias Mipha.Notifications.UserNotification

    @valid_attrs %{notification_id: 42, read_at: ~N[2010-04-17 14:00:00.000000], user_id: 42}
    @update_attrs %{notification_id: 43, read_at: ~N[2011-05-18 15:01:01.000000], user_id: 43}
    @invalid_attrs %{notification_id: nil, read_at: nil, user_id: nil}

    def user_notification_fixture(attrs \\ %{}) do
      {:ok, user_notification} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Notifications.create_user_notification()

      user_notification
    end

    test "list_users_notifications/0 returns all users_notifications" do
      user_notification = user_notification_fixture()
      assert Notifications.list_users_notifications() == [user_notification]
    end

    test "get_user_notification!/1 returns the user_notification with given id" do
      user_notification = user_notification_fixture()
      assert Notifications.get_user_notification!(user_notification.id) == user_notification
    end

    test "create_user_notification/1 with valid data creates a user_notification" do
      assert {:ok, %UserNotification{} = user_notification} = Notifications.create_user_notification(@valid_attrs)
      assert user_notification.notification_id == 42
      assert user_notification.read_at == ~N[2010-04-17 14:00:00.000000]
      assert user_notification.user_id == 42
    end

    test "create_user_notification/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Notifications.create_user_notification(@invalid_attrs)
    end

    test "update_user_notification/2 with valid data updates the user_notification" do
      user_notification = user_notification_fixture()
      assert {:ok, user_notification} = Notifications.update_user_notification(user_notification, @update_attrs)
      assert %UserNotification{} = user_notification
      assert user_notification.notification_id == 43
      assert user_notification.read_at == ~N[2011-05-18 15:01:01.000000]
      assert user_notification.user_id == 43
    end

    test "update_user_notification/2 with invalid data returns error changeset" do
      user_notification = user_notification_fixture()
      assert {:error, %Ecto.Changeset{}} = Notifications.update_user_notification(user_notification, @invalid_attrs)
      assert user_notification == Notifications.get_user_notification!(user_notification.id)
    end

    test "delete_user_notification/1 deletes the user_notification" do
      user_notification = user_notification_fixture()
      assert {:ok, %UserNotification{}} = Notifications.delete_user_notification(user_notification)
      assert_raise Ecto.NoResultsError, fn -> Notifications.get_user_notification!(user_notification.id) end
    end

    test "change_user_notification/1 returns a user_notification changeset" do
      user_notification = user_notification_fixture()
      assert %Ecto.Changeset{} = Notifications.change_user_notification(user_notification)
    end
  end
end
