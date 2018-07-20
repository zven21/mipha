defmodule MiphaWeb.PersonView do
  use MiphaWeb, :view

  alias Mipha.Accounts

  @doc """
  获取当前 team 下 所有 user_teams.
  """
  def get_user_teams(team) do
    Accounts.get_user_teams(team)
  end
end
