defmodule MiphaWeb.Plug.Attack do
  @moduledoc """
  attack
  """

  import Plug.Conn
  use PlugAttack

  rule("throttle by ip every 2 minutes only allow register 10 person", conn) do
    if conn.method == "POST" and conn.path_info == ["join"] do
      throttle(conn.remote_ip,
        period: 120_000,
        limit: 10,
        storage: {PlugAttack.Storage.Ets, Mipha.PlugAttack.Storage}
      )
    end
  end

  rule("throttle by ip every 1 hours only allow create 20 topic", conn) do
    if conn.method == "POST" and conn.path_info == ["topics"] do
      throttle(conn.remote_ip,
        period: 3_600_000,
        limit: 20,
        storage: {PlugAttack.Storage.Ets, Mipha.PlugAttack.Storage}
      )
    end
  end

  rule("throttle by ip every 2 minutes only allow create 20 reply", conn) do
    if conn.method == "POST" and conn.path_info == ["topics"] do
      throttle(conn.remote_ip,
        period: 120_000,
        limit: 20,
        storage: {PlugAttack.Storage.Ets, Mipha.PlugAttack.Storage}
      )
    end
  end

  def allow_action(conn, {:throttle, data}, opts) do
    conn
    |> add_throttling_headers(data)
    |> allow_action(true, opts)
  end

  def allow_action(conn, _data, _opts) do
    conn
  end

  def block_action(conn, {:throttle, data}, opts) do
    conn
    |> add_throttling_headers(data)
    |> block_action(false, opts)
  end

  def block_action(conn, _data, _opts) do
    conn
    |> send_resp(:forbidden, "Forbidden \n")
    |> halt()
  end

  defp add_throttling_headers(conn, data) do
    # in seconds
    reset = div(data[:expires_at], 1_000)

    conn
    |> put_resp_header("x-ratelimit-limit", to_string(data[:limit]))
    |> put_resp_header("x-ratelimit-remaining", to_string(data[:remaining]))
    |> put_resp_header("x-ratelimit-reset", to_string(reset))
  end
end
