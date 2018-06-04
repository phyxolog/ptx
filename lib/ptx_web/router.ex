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

    plug Guardian.Plug.VerifyHeader, claims: %{typ: "access"}, realm: :none
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
    get "/getting-started", PageController, :dummy
  end

  scope "/:locale", PtxWeb do
    pipe_through [:browser, :locale, :auth]

    get "/pricing", PageController, :pricing
    get "/getting-started", PageController, :getting_started
  end

  scope "/", PtxWeb do
    pipe_through [:browser, :auth]

    get "/pay", PayController, :index
  end

  scope "/auth", PtxWeb do
    pipe_through [:browser, :auth]

    get "/google", AuthController, :request
    get "/google/callback", AuthController, :callback
  end

  get "/link", PtxWeb.LinkTrackerController, :index

  scope "/api", PtxWeb do
    pipe_through :api

    get "/trace/mail/:id", TraceController, :index
    get "/translations", TranslationController, :index
    get "/timestamp", ApiController, :timestamp
    get "/timezones", ApiController, :timezones

    get "/faq/list", FaqController, :list
    get "/faq/:id", FaqController, :show

    get "/plan/list", PlanController, :list
    get "/plan/:id", PlanController, :show

    get "/pages/:id", PagesController, :index

    match :*, "/liqpay/callback", LiqPayController, :callback
  end

  scope "/api", PtxWeb do
    pipe_through [:api, :auth]

    get "/identity", ApiController, :identity
    get "/link/:id", LinkController, :show

    post "/messages/list", MessageController, :index
    resources "/messages", MessageController, only: [:create]
    resources "/users", UserController, only: [:update] do
      # get "/statistic/time-and-count", UserController, :time_and_count
      # get "/statistic/date-and-count", UserController, :date_and_count
      # get "/statistic/open-and-time", UserController, :open_and_time
      # get "/statistic/open-and-count", UserController, :open_and_count
      get "/recipients", UserController, :recipients
      get "/statistic", UserController, :statistic
      get "/statistic/links", UserController, :links_statistic
      post "/unsubscribe", UserController, :unsubscribe
    end
  end
end
