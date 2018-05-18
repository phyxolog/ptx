defmodule PtxWeb.Router do
  use PtxWeb, :router

  @default_locale Application.get_env(:ptx, PtxWeb.Gettext)[:default_locale]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :locale do
    ## Support multilanguage
    plug SetLocale, gettext: PtxWeb.Gettext, default_locale: @default_locale
  end

  pipeline :auth do
    plug Guardian.Plug.Pipeline,
      error_handler: PtxWeb.SessionController,
      otp_app: :ptx,
      module: Ptx.Guardian,
      key: "default"

    plug Guardian.Plug.VerifyHeader, realm: :none
    plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
    plug Guardian.Plug.LoadResource, allow_blank: true
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  ## We need a dummy entry points for support default root
  ## without locale
  scope "/", PtxWeb do
    pipe_through [:browser, :locale, :auth]

    get "/pricing", PageController, :dummy
  end

  scope "/", PtxWeb do
    pipe_through [:browser, :auth]

    get "/pay", PayController, :index
  end

  scope "/:locale", PtxWeb do
    pipe_through [:browser, :locale, :auth]

    get "/pricing", PageController, :pricing
  end

  scope "/auth", PtxWeb do
    pipe_through [:browser, :auth]

    get "/google", AuthController, :request
    get "/google/callback", AuthController, :callback
  end

  scope "/api", PtxWeb do
    pipe_through [:api, :auth]

    get "/translations", TranslationController, :index
    get "/timestamp", ApiController, :timestamp
    get "/identity", ApiController, :identity
    get "/timezones", ApiController, :timezones

    resources "/messages", MessageController, only: [:create]
    resources "/users", UserController, only: [:update]
    resources "/faq", FaqController, only: [:index]

    match :*, "/liqpay/callback", LiqPayController, :callback
  end
end

# get "/lt", PtWeb.LinkTrackerController, :index
# get "/lt/:url", PtWeb.LinkTrackerController, :url

# scope path: "/api/v1", as: :api_v1, alias: PtWeb do
#   pipe_through :api

#   get "/stats", ApiController, :stats
#   post "/unsubscribe", ApiController, :unsubscribe

#   get "/lt", EmailLinkController, :index

#   get "/trace/mail/:id", EmailController, :trace

#   post "/email_checker", EmailController, :email_checker
# end
