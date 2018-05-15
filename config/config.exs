# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :ptx,
  ecto_repos: [Ptx.Repo]

config :ptx, PtxWeb.Gettext,
  default_locale: "ru",
  locales: ~w(en ru uk)

# Configures the endpoint
config :ptx, PtxWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "aKqpWt31ARgW+XNbRl9UCMaoJhT0YW4wO1geeNQnZubdLRyyR4QsZRnj48cwozdw",
  render_errors: [view: PtxWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Ptx.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Use Jason for JSON parsing in Phoenix and Ecto
config :phoenix, :json_library, Jason
config :ecto, :json_library, Jason
config :phoenix,
  format_encoders: [json: Jason]

config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, [default_scope: "email profile https://mail.google.com/"]}
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: "457128893119-as5ctpvf6r1e116eni0o6erij3viq3oh.apps.googleusercontent.com",
  client_secret: "5VeMRO5rTdFxDZh4Ak_LmOtB"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
