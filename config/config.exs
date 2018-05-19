# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :ptx,
  from_email_string: "PostTrack Alerts <noreply@posttrack.com>",
  env: Mix.env(),
  url: "https://stupid-zebra-57.localtunnel.me",
  currency: "USD",
  trial_period: 14,
  ticket_email: "posttrack@sloenka.com",
  ecto_repos: [Ptx.Repo],
  plans: ~w(trial basic pro)a,
  prices: %{
    basic: %{
      month: 5,
      year: 12
    },

    pro: %{
      month: 8,
      year: 24
    }
  }

config :ptx, PtxWeb.Gettext,
  default_locale: "ru",
  locales: ~w(en ru uk)

config :exliqpay,
  public_key: "i34689789506",
  private_key: "XqKEpPpqouvQa9AGBnNEuc0Pn2h8gvTwuJjhOFbW"

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
    google: {Ueberauth.Strategy.Google, [
      default_scope: ~s(email profile https://mail.google.com/ https://www.googleapis.com/auth/gmail.modify https://www.googleapis.com/auth/gmail.compose),
      access_type: "offline",
      prompt: "consent"
    ]}
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: "457128893119-as5ctpvf6r1e116eni0o6erij3viq3oh.apps.googleusercontent.com",
  client_secret: "5VeMRO5rTdFxDZh4Ak_LmOtB"

config :ptx, Ptx.Guardian,
  ttl: {30, :days},
  allowed_algos: ["HS256"],
  issuer: "ptx",
  secret_key: "MZr8o2ruAEM/eFVAp7NcAjWJF8ufbFMIsFw4ekRU2i6DWH0CQYHiwbMquM06/wHz"

config :guardian, Guardian.DB,
  repo: Ptx.Repo,
  schema_name: "guardian_tokens",
  sweep_interval: 60

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
