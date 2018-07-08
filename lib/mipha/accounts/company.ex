defmodule Mipha.Accounts.Company do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias Mipha.Accounts.{User, Location, Company}

  @type t :: %Company{}

  schema "companies" do
    field :name, :string
    field :avatar, :string

    belongs_to :location, Location

    has_many :users, User

    timestamps()
  end

  @doc false
  def changeset(company, attrs) do
    permitted_attrs = ~w(
      name
      avatar
      location_id
    )a

    required_attrs = ~w(
      name
      location_id
    )a

    company
    |> cast(attrs, permitted_attrs)
    |> validate_required(required_attrs)
  end
end
