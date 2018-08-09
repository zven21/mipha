defmodule Mipha.Mixfile do
  use Mix.Project

  def project do
    [
      app: :mipha,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps()
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
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.3"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:credo, "~> 0.10.0", only: [:dev, :test], runtime: false},
      {:comeonin, "~> 4.1"},
      {:bcrypt_elixir, "~> 1.0"},
      {:ueberauth, "~> 0.5.0"},
      {:ueberauth_identity, "~> 0.2.3"},
      {:ueberauth_github, "~> 0.7.0"},
      {:faker, "~> 0.10.0"},
      {:earmark, "~> 1.2"},
      {:html_sanitize_ex, "~> 1.3"},
      {:timex, "~> 3.3"},
      {:qiniu, "~> 0.4.0"},
      {:exmoji, "~> 0.2.2"},
      {:bamboo, "~> 1.0"},
      {:bamboo_smtp, "~> 1.5"},
      {:ecto_enum, "~> 1.1"},
      {:cachex, "~> 3.0"},
      {:jason, "~> 1.1"},
      {:poison, "~> 3.0", override: true},
      {:captcha, github: "zven21/elixir-captcha"},
      {:turbo_ecto, "0.1.3"},
      {:turbo_html, "0.1.3"},
      {:remote_ip, "~> 0.1.4"},
      {:plug_attack, "~> 0.3.1"},
      {:sentry, "~> 6.4"},
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
