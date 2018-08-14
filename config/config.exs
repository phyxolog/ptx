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
  url: "https://posttrack.email",
  currency: "USD",
  trial_period: 14,
  ticket_email: "posttrack@sloenka.com",
  ecto_repos: [Ptx.Repo],
  plans: ~w(trial basic pro)a,
  prices: %{
    month: 4.99,
    year: 11.99
  }
  # prices: %{
  #   basic: %{
  #     month: 4.99,
  #     year: 11.99
  #   },

  #   pro: %{
  #     month: 7.99,
  #     year: 19.99
  #   }
  # }

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
      request_path: "/auth/google/request",
      default_scope: ~s(email profile),
      # default_scope: ~s(email profile https://www.googleapis.com/auth/gmail.send),
      access_type: "offline",
      prompt: "force"
    ]}
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: "478003371123-gl3ni8o1csbc8ttq54k0d7fdiv8nc06i.apps.googleusercontent.com",
  client_secret: "T3zrZtuiLOcIHxCtqNa69ET3"

config :ptx, Ptx.Guardian,
  ttl: {30, :days},
  allowed_algos: ["HS256"],
  issuer: "ptx",
  secret_key: "MZr8o2ruAEM/eFVAp7NcAjWJF8ufbFMIsFw4ekRU2i6DWH0CQYHiwbMquM06/wHz"

config :guardian, Guardian.DB,
  repo: Ptx.Repo,
  schema_name: "guardian_tokens",
  sweep_interval: 60

config :ptx, Ptx.Mailer,
  adapter: Bamboo.MailgunAdapter,
  domain: "mg.posttrack.sloenka.com",
  api_key: "key-a6a3629f652448644d04d1c4aefe43bc"

config :ptx, Ptx.Scheduler,
  timezone: "Europe/Kiev",
  jobs: [
    {"@hourly", {Ptx.Accounts, :freeze_and_list_expired_users, []}}
#     {"@hourly", {Ptx.Accounts, :list_expiring_tomorrow_users, []}}
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
