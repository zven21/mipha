defmodule Mipha.Qiniu do
  @moduledoc false

  @base_url "http://pbfwruvmm.bkt.clouddn.com/"
  @bucket "mipha"

  def upload(path) do
    @bucket
    |> Qiniu.PutPolicy.build()
    |> Qiniu.Uploader.upload(path, key: generate_key())
  end

  @doc """
  获取七牛的链接地址
  """
  def q_url(value) when is_nil(value) do
    @base_url <> "default.jpg"
  end

  def q_url(value) do
    @base_url <> value
  end

  defp generate_key do
    "#{Timex.to_unix(Timex.now())}/#{Enum.random(1..1_000)}.jpg"
  end
end
