defmodule Ptx.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ptx,
      version: "0.0.63",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Ptx.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      ## For building releases and deploying
      {:distillery, "~> 1.5.2", runtime: false},
      {:edeliver, "~> 1.5.0"},

      ## Main deps
      {:phoenix, "~> 1.3.2"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.11.2"},
      {:phoenix_live_reload, "~> 1.1.5", only: :dev},
      {:gettext, "~> 0.15.0", override: true},
      {:cowboy, "~> 1.1.2"},
      {:jason, "~> 1.0.0"},

      ## For multilanguage support
      {:set_locale, "~> 0.2.4"},

      ## For time formatting/parsing
      {:timex, "~> 3.3.0"},

      ## Job scheduler
      {:crontab, github: "jshmrtn/crontab", override: true},
      {:quantum, github: "quantum-elixir/quantum-core"},

      ## Email library
      {:bamboo, "~> 0.8.0"},

      ## HTTP Client
      {:httpoison, "~> 1.1.1"},

      ## Error handling
      {:ok, "~> 1.10.0"},

      ## Google OAuth2
      {:ueberauth_google, "~> 0.7.0"},
      {:guardian, "~> 1.0.1"},
      {:guardian_db, github: "ueberauth/guardian_db"},

      ## For payments with Liqpay
      {:exliqpay, git: "git@bitbucket.org:theengineerscrew/exliqpay-lib.git"},

      ## For pagination in Ecto
      {:scrivener_ecto, "~> 1.3.0"},

      ## For static analysis
      {:credo, "~> 0.9.2", only: [:dev, :test], runtime: false},
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
