# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :order_api,
  ecto_repos: [OrderApi.Repo]

# Configures the endpoint
config :order_api, OrderApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "nhEQyTgvnq1Gtxgn4cVYMfRiGkTdc4Ab8OWCX+TNJA1PM8xWhadTNdW+kSX/CXEa",
  render_errors: [view: OrderApiWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: OrderApi.PubSub,
  live_view: [signing_salt: "Zv3UFHel"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
