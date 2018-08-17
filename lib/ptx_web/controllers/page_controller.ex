defmodule PtxWeb.PageController do
  use PtxWeb, :controller
  use Guardian.Phoenix.Controller
  import PtxWeb.Gettext

  @url Application.get_env(:ptx, :url)
  @locales Application.get_env(:ptx, PtxWeb.Gettext)[:locales]

  # def pricing(conn, _params, user) do
  #   current_locale = conn.assigns.locale

  #   meta_locales = @locales -- [current_locale]
  #   |> Enum.map(fn locale -> [property: "og:locale:alternate", content: locale] end)

  #   meta = [
  #     [property: "og:locale", content: current_locale],
  #     [property: "og:og:url", content: "#{@url}#{conn.request_path}"],
  #     [property: "og:type", content: "website"],
  #     [property: "og:og:image", content: PtxWeb.Endpoint.static_path("/images/og/pricing_#{current_locale}.png")]
  #   ]

  #   conn
  #   |> assign(:user, user)
  #   |> assign(:title, gettext("Pricing"))
  #   |> assign(:og_meta, meta ++ meta_locales)
  #   |> render("pricing.html")
  #   # redirect(conn, to: "/office")
  # end

  def pricing(conn, _params, user) do
    current_locale = conn.assigns.locale

    meta_locales = @locales -- [current_locale]
    |> Enum.map(fn locale -> [property: "og:locale:alternate", content: locale] end)

    meta = [
      [property: "og:locale", content: current_locale],
      [property: "og:og:url", content: "#{@url}#{conn.request_path}"],
      [property: "og:type", content: "website"],
      [property: "og:og:image", content: PtxWeb.Endpoint.static_path("/images/og/pricing_#{current_locale}.png")]
    ]

    plan = if !is_nil(user),
      do: Map.get(user, :plan), 
      else: nil

    conn
    |> assign(:user_plan, plan)
    |> assign(:title, gettext("Pricing"))
    |> assign(:og_meta, meta ++ meta_locales)
    |> render("pricing.html")
    # redirect(conn, to: "/office")
  end

  def getting_started(conn, _params, _user) do
    conn
    |> assign(:pass_style, true)
    |> render("getting_started.html")
  end

  def office(conn, _params, nil), do: redirect conn, external: "#{@url}"
  def office(conn, _params, %{plan: nil}), do: redirect conn, external: "#{@url}/pricing"
  def office(conn, _params, _user) do
    conn
    |> put_layout(false)
    |> render("office.html")
  end

  def to_mail(conn, params, _user) do
    case Map.get(params, "authuser") do
      nil -> redirect(conn, external: "https://mail.google.com/")
      mail -> redirect(conn, external: "https://mail.google.com/mail?authuser=#{mail}")
    end
  end
end
