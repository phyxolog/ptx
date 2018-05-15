defmodule PtxWeb.Router do
  use PtxWeb, :router

  @default_locale Application.get_env(:ptx, PtxWeb.Gettext)[:default_locale]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Ueberauth
  end

  pipeline :locale do
    ## Support multilanguage
    plug SetLocale, gettext: PtxWeb.Gettext, default_locale: @default_locale
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  ## We need a dummy entry points for support default root
  ## without locale
  scope "/", PtxWeb do
    pipe_through [:browser, :locale]

    get "/pricing", PageController, :dummy
  end

  scope "/:locale", PtxWeb do
    pipe_through [:browser, :locale]

    get "/pricing", PageController, :pricing
  end

  scope "/auth", PtxWeb do
    pipe_through :browser

    get "/google", AuthController, :request
    get "/google/callback", AuthController, :callback
  end

  scope "/api", PtxWeb do
    pipe_through :api
  end
end
