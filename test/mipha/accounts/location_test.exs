defmodule Mipha.Accounts.LocationTest do
  use Mipha.DataCase

  alias Mipha.Accounts.Location

  @valid_attrs %{name: "some-location"}
  @invalid_attrs %{name: nil}

  describe "changeset" do
    test "with valid attrs" do
      changeset = Location.changeset(%Location{}, @valid_attrs)
      assert changeset.valid?
    end

    test "with invalid attrs" do
      changeset = Location.changeset(%Location{}, @invalid_attrs)
      refute changeset.valid?
    end
  end
end
