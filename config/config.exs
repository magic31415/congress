# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :congress,
  ecto_repos: [Congress.Repo]

# Configures the endpoint
config :congress, CongressWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "b1IFAwNGuVQwmB1RwKnY4R/q4BC6Tcu3tvfFPCpfl2F3eZ96ZPximX/wT++iURDx",
  render_errors: [view: CongressWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Congress.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
import_config "keys.secret.exs"
