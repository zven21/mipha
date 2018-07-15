defmodule Mipha.Utils.Store do
  @moduledoc """
  文件储存
  """

  alias Cachex

  @doc """
  读取文件信息

  ## Example

      iex> Mipha.Utils.Store.get(a)
      {:ok, "b"}

  """
  def get(cache_key) do
    Cachex.get(:app_cache, cache_key)
  end

  def get!(cache_key) do
    Cachex.get!(:app_cache, cache_key)
  end

  @doc """
  储存信息
  """
  def put(cache_key, cache_value) do
    Cachex.put(:app_cache, cache_key, cache_value)
  end

  def put!(cache_key, cache_value) do
    Cachex.put!(:app_cache, cache_key, cache_value)
  end
end