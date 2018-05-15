defmodule PtxWeb.Router do
  use PtxWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    ## Support multilanguage
    plug SetLocale, gettext: PtxWeb.Gettext, default_locale: "ru"
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  ## We need a dummy entry point for support default root
  ## without locale
  scope "/", PtxWeb do
    pipe_through :browser
    get "/", PageController, :dummy
  end

  scope "/:locale", PtxWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", PtxWeb do
  #   pipe_through :api
  # end
end
