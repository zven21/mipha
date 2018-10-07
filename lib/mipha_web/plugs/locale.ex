defmodule MiphaWeb.Plug.Locale do
  @moduledoc """
  Locale, support: 简体中文 and English
  """

  import Plug.Conn

  def init(_opts), do: nil

  def call(conn, _opts) do
    case conn.params["locale"] || get_session(conn, :locale) do
      nil ->
        conn

      locale ->
        Gettext.put_locale(MiphaWeb.Gettext, locale)
        conn |> put_session(:locale, locale)
    end
  end
end
