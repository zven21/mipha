defmodule Mipha.Stars do
  @moduledoc """
  The Stars context.
  """

  import Ecto.Query, warn: false
  alias Mipha.Repo

  alias Mipha.Stars.Star

  @doc """
  Returns the list of stars.

  ## Examples

      iex> list_stars()
      [%Star{}, ...]

  """
  def list_stars do
    Repo.all(Star)
  end

  @doc """
  Gets a single star.

  Raises `Ecto.NoResultsError` if the Star does not exist.

  ## Examples

      iex> get_star!(123)
      %Star{}

      iex> get_star!(456)
      ** (Ecto.NoResultsError)

  """
  def get_star!(id), do: Repo.get!(Star, id)

  @doc """
  Creates a star.

  ## Examples

      iex> create_star(%{field: value})
      {:ok, %Star{}}

      iex> create_star(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_star(attrs \\ %{}) do
    %Star{}
    |> Star.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a star.

  ## Examples

      iex> update_star(star, %{field: new_value})
      {:ok, %Star{}}

      iex> update_star(star, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_star(%Star{} = star, attrs) do
    star
    |> Star.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Star.

  ## Examples

      iex> delete_star(star)
      {:ok, %Star{}}

      iex> delete_star(star)
      {:error, %Ecto.Changeset{}}

  """
  def delete_star(%Star{} = star) do
    Repo.delete(star)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking star changes.

  ## Examples

      iex> change_star(star)
      %Ecto.Changeset{source: %Star{}}

  """
  def change_star(%Star{} = star) do
    Star.changeset(star, %{})
  end
end
