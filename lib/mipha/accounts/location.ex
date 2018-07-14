defmodule Mipha.Accounts.Location do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Mipha.Accounts.{User, Location}

  @type t :: %Location{}

  schema "locations" do
    field :name, :string

    has_many :users, User

    timestamps()
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
