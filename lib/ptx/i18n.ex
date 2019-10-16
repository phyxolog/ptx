defmodule I18n do
  defmacro i18n(fields) do
    quote do
      @locales Application.get_env(:ptx, PtxWeb.Gettext)[:locales]
      for %{name: name, type: type} <- unquote(fields), language <- @locales, do:
        field :"#{name}_#{language}", type
    end
  end

  @locales Application.get_env(:ptx, PtxWeb.Gettext)[:locales]
  def cast(translations, cast) do
    our_cast = for %{name: name} <- translations, language <- @locales, do:
      String.to_atom "#{name}_#{language}"

    cast ++ our_cast
  end
end
