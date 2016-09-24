# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :elixir_job_board,
  ecto_repos: [ElixirJobBoard.Repo]

# Configures the endpoint
config :elixir_job_board, ElixirJobBoard.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "KJKCTKJxccPyPW8jEir6K4qRt/qEkHqmPx3haGGuxDsx0uhVDu531MlKaCrOdT4E",
  render_errors: [view: ElixirJobBoard.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ElixirJobBoard.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
