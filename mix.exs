defmodule Mipha.Mixfile do
  use Mix.Project

  def project do
    [
      app: :mipha,
      version: "0.0.1",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Mipha.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.1"},
      {:phoenix_pubsub, "~> 2.0"},
      {:phoenix_ecto, "~> 4.0"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.1"},
      {:plug_cowboy, "~> 2.0"},
      {:plug, "~> 1.7"},
      {:credo, "~> 1.0"},
      {:comeonin, "~> 4.1"},
      {:bcrypt_elixir, "~> 1.0"},
      {:ueberauth, "~> 0.5.0"},
      {:ueberauth_identity, "~> 0.2.3"},
      {:ueberauth_github, "~> 0.7.0"},
      {:faker, "~> 0.10.0"},
      {:earmark, "~> 1.2.6"},
      {:html_sanitize_ex, "~> 1.3"},
      {:timex, "~> 3.3"},
      {:ecto_enum, "~> 1.1"},
      {:qiniu, "~> 0.4.0"},
      {:exmoji, "~> 0.2.2"},
      {:bamboo, "~> 1.0"},
      {:bamboo_smtp, "~> 2.1"},
      {:cachex, "~> 3.3.0"},
      {:poison, "~> 4.0", override: true},
      {:captcha, github: "zven21/elixir-captcha"},
      {:turbo_ecto, github: "zven21/turbo_ecto"},
      {:turbo_html, github: "zven21/turbo_html"},
      {:remote_ip, "~> 0.1.4"},
      {:plug_attack, "~> 0.3.1"},
      {:sentry, "~> 6.4"},
      {:ex_machina, "~> 2.4.0"},
      {:excoveralls, "~> 0.10", only: :test}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
