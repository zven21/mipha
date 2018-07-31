# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :mipha,
  ecto_repos: [Mipha.Repo]

# Configures the endpoint
config :mipha, MiphaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Gbwl1EqAtjdYfG5movSWszQHvrppYxDbg/7xegRJSakWiTTl6ypdMpNgNct3LiDx",
  render_errors: [view: MiphaWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Mipha.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [default_scope: "user:email", allow_private_emails: true]},
    identity: {Ueberauth.Strategy.Identity, [callback_methods: ["POST"]]},
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET")

config :qiniu, Qiniu,
  access_key: System.get_env("QINIU_ACCESS_KEY"),
  secret_key: System.get_env("QINIU_SECRET_KEY")

config :mipha, Mipha.Mailer,
  adapter: Bamboo.LocalAdapter

# Sentry
config :sentry,
  dsn: System.get_env("SENRTY_DSN"),
  included_environments: [:prod],
  environment_name: Mix.env(),
  enable_source_code_context: true,
  root_source_code_path: File.cwd!()

config :trubo_ecto, Trubo.Ecto,
  repo: Mipha.Repo

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
