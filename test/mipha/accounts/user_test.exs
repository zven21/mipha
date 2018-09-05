defmodule Mipha.Accounts.UserTest do
  use Mipha.DataCase

  alias Mipha.Accounts.User

  @valid_attrs %{username: "some-username", email: "zven21@mipha.com"}
  @invalid_attrs %{username: nil, email: nil}

  describe "changeset" do
    test "with valid attrs" do
      changeset = User.changeset(%User{}, @valid_attrs)
      assert changeset.valid?
    end

    test "with invalid attrs" do
      changeset = User.changeset(%User{}, @invalid_attrs)
      refute changeset.valid?
    end
  end
end
