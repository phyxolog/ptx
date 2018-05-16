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
      otp_app: :ptx,
      module: Ptx.Guardian,
      key: "default",
      error_handler: PtxWeb.SessionController

    plug Guardian.Plug.VerifyHeader, realm: :none
    plug Guardian.Plug.VerifyCookie, exchange_from: "access"
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

  scope "/api" do
    pipe_through :api

    resources "/users", UserController, only: [:show, :update]
  end
end
