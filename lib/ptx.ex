defmodule Ptx do
  @moduledoc """
  Ptx keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  import PtxWeb.Gettext

  def get_timezone_offset_by_name(timezone) do
    Timex.Timezone.get(timezone)
    |> Timex.Timezone.total_offset()
    |> Kernel./(3600)
    |> Float.round()
  end

  def relative_diff_date(sent_email_date, read_email_date, locale) do
    duration = Timex.diff(read_email_date, sent_email_date, :duration)
    Timex.Format.Duration.Formatter.lformat(duration, locale, :humanized)
  end

  @doc """
  Convert integer to binary
  """
  def to_i(nil), do: nil
  def to_i(i) when is_integer(i), do: i
  def to_i(s) when is_binary(s) do
    case Integer.parse(s) do
      {i, _} -> i
      :error -> nil
    end
  end

  def translate_plan(plan, user) do
    Gettext.with_locale(PtxWeb.Gettext, user.locale, fn ->
      case String.downcase(to_string(plan)) do
        "trial" -> gettext "Trial"
        "basic" -> gettext "Basic"
        "pro" -> gettext "Pro"
      end
    end)
  end
end
