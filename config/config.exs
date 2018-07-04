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
    github: {Ueberauth.Strategy.Github, [default_scope: ""]},
    identity: {Ueberauth.Strategy.Identity, [callback_methods: ["POST"]]},
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET")

# scrivener_html
config :scrivener_html,
  routes_helper: MiphaWeb.Router.Helpers,
  view_style: :bootstrap_v4

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
