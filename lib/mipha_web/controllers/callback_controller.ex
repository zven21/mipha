defmodule MiphaWeb.CallbackController do
  use MiphaWeb, :controller

  alias Mipha.Qiniu

  @doc """
  上传图片回调方法。
  """
  def qiniu(conn, %{"file" => file_params}) do
    with %HTTPoison.Response{status_code: 200, body: body} <- Qiniu.upload(file_params.path) do
      conn
      |> json(%{qn_url: Qiniu.q_url(body["key"])})
    end
  end
end
