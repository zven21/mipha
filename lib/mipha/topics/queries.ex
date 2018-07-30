defmodule Mipha.Topics.Queries do
  @moduledoc false

  alias Mipha.Topics.Topic

  @doc """
  Returns the list topics.
  """
  @spec topics(Map.t()) :: Map.t()
  def topics(params), do: Trubo.Ecto.trubo(Topic, params)
end
