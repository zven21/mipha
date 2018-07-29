defmodule MiphaWeb.Ransack do
  @moduledoc false

  alias MiphaWeb.Ransack.{Form, Paginate}

  @doc """
  Ransack 的分页 View
  """
  def ransack_pagination_links(paginator) do
    Paginate.ransack_pagination_links(paginator)
  end
end
