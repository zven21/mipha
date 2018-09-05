defmodule Mipha.Accounts.AccountTest do
  use Mipha.DataCase

  alias Mipha.Accounts.Company

  @valid_attrs %{name: "some-company", location_id: 1}
  @invalid_attrs %{name: "some-company", location_id: nil}

  describe "changeset" do
    test "with valid attrs" do
      changeset = Company.changeset(%Company{}, @valid_attrs)
      assert changeset.valid?
    end

    test "with invalid attrs" do
      changeset = Company.changeset(%Company{}, @invalid_attrs)
      refute changeset.valid?
    end
  end
end
