# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :hello_stage,
  ecto_repos: [HelloStage.Repo]

# Configures the endpoint
config :hello_stage, HelloStageWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ewFBxbBBERUUgxhsPqXEJfJ83YQ2F8YpQ0SkynAUSLMkMONhzDIx/zFYpYiTNO3U",
  render_errors: [view: HelloStageWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: HelloStage.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
