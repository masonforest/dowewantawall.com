# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :twitter_poll,
  ecto_repos: [TwitterPoll.Repo]

# Configures the endpoint
config :twitter_poll, TwitterPollWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "X5V88N++4C9A2j0BcmhW5rHdJcgHGsSnj9bVZeUK4x4XX4kuG2zgWOYvAzD0nsyv",
  render_errors: [view: TwitterPollWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TwitterPoll.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
import_config "#{Mix.env()}.secret.exs"
