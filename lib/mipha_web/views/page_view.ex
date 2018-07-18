defmodule MiphaWeb.PageView do
  use MiphaWeb, :view

  def split_topics(topics) do
    topics
    |> Enum.with_index
    |> Enum.split_with(fn {_, i} -> rem(i, 2) == 0 end)
  end
end
