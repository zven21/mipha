defmodule Mipha.Application do
  @moduledoc false

  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Mipha.Repo, []),
      # Start the endpoint when the application starts
      supervisor(MiphaWeb.Endpoint, []),
      supervisor(MiphaWeb.Presence, []),
      # Start your own worker by calling: Mipha.Worker.start_link(arg1, arg2, arg3)
      worker(Cachex, [:app_cache, []]),
      worker(PlugAttack.Storage.Ets, [Mipha.PlugAttack.Storage, [clean_period: 60_000]])
      # worker(Mipha.Worker, [arg1, arg2, arg3]),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Mipha.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MiphaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
