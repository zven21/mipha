defmodule MiphaWeb.TeamView do
  use MiphaWeb, :view

  def is_owner?(team, user) do
    team.owner_id == user.id
  end
end
