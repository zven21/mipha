defmodule Mipha.Accounts.User do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias Comeonin.Bcrypt

  alias Mipha.{
    Regexp,
    Topics.Topic,
    Replies.Reply,
    Follows.Follow,
    Stars.Star,
    Collections.Collection
  }

  alias Mipha.Accounts.{User, Location, Company, Team, UserTeam}

  @type t :: %User{}

  schema "users" do
    field :username, :string
    field :avatar, :string
    field :bio, :string
    field :email, :string
    field :email_public, :boolean, default: false
    field :email_verified_at, :naive_datetime
    field :tagline, :string
    field :github_handle, :string
    field :is_admin, :boolean, default: false
    field :password_hash, :string
    field :website, :string
    field :alipay, :string
    field :wechat, :string
    field :locked_at, :naive_datetime
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :login, :string, virtual: true
    field :reset_password_token, :string, virtual: true

    belongs_to :location, Location
    belongs_to :company, Company

    has_many :topics, Topic, on_delete: :delete_all
    has_many :replies, Reply, on_delete: :delete_all
    has_many :followers, Follow, on_delete: :delete_all
    has_many :following, Follow, foreign_key: :follower_id
    has_many :stars, Star, on_delete: :delete_all
    has_many :collections, Collection, on_delete: :delete_all

    many_to_many :teams, Team, join_through: UserTeam

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    permitted_attrs = ~w(
      username
      email
      avatar
      bio
      website
      github_handle
      is_admin
      location_id
      company_id
      tagline
      email_public
      wechat
      alipay
      email_verified_at
    )a

    required_attrs = ~w(
      username
      email
    )a

    user
    |> cast(attrs, permitted_attrs)
    |> validate_required(required_attrs)
  end

  @doc """
  User login changeset.
  """
  def login_changeset(user, attrs) do
    login_attrs = ~w(
      login
      password
    )a

    user
    |> cast(attrs, login_attrs)
    |> validate_required(login_attrs)
  end

  @doc """
  Registration changeset.
  """
  def register_changeset(user, attrs) do
    permitted_attrs = ~w(
      username
      email
      password
      avatar
      is_admin
      bio
      website
      github_handle
      company_id
      location_id
    )a

    register_attrs = ~w(
      username
      email
      password
    )a

    user
    |> cast(attrs, permitted_attrs)
    |> validate_required(register_attrs)
    |> validate_length(:username, min: 3, max: 12)
    |> validate_format(:username, Regexp.username)
    |> unique_constraint(:username)
    |> validate_length(:email, min: 1, max: 20)
    |> validate_format(:email, Regexp.email)
    |> unique_constraint(:email)
    |> put_pass_hash()
  end

  @doc """
  Change user password.
  """
  @spec update_password_changeset(User.t(), map()) :: Ecto.Changeset.t()
  def update_password_changeset(user, attrs) do
    required_attrs = ~w(
      password
      password_confirmation
    )a

    user
    |> cast(attrs, required_attrs)
    |> validate_required(required_attrs)
    |> validate_password_confirmation
    |> put_pass_hash
  end

  # def forgot_password_changeset(user, attrs) do
  #   required_attrs = ~w(email)a

  #   user
  #   |> cast(attrs, required_attrs)
  #   |> validate_required(required_attrs)
  # end

  @doc """
  Reset Password when user forgot password.
  """
  @spec reset_password_changeset(User.t(), map()) :: Ecto.Changeset.t()
  def reset_password_changeset(user, attrs) do
    required_attrs = ~w(
      reset_password_token
      password
      password_confirmation
    )a

    user
    |> cast(attrs, required_attrs)
    |> validate_required(required_attrs)
    |> validate_password_confirmation
    |> put_pass_hash
  end

  defp validate_password_confirmation(%{changes: changes} = changeset) do
    if changes[:password] == changes[:password_confirmation],
      do: changeset,
      else: add_error(changeset, :password_confirmation, "must match password")
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Bcrypt.hashpwsalt(password))
      _ ->
        changeset
    end
  end
end
