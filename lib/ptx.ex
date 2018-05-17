defmodule Ptx do
  @moduledoc """
  Ptx keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  import PtxWeb.Gettext, only: [gettext: 1]

  @doc """
  Get timezone offset by name.
  """
  def get_timezone_offset_by_name(timezone) do
    Timex.Timezone.get(timezone)
    |> Timex.Timezone.total_offset()
    |> Kernel./(3600)
    |> Float.round()
  end

  @doc """
  Pad leading number.
  """
  def pad(number) do
    abs(number)
    |> Integer.to_string()
    |> String.pad_leading(2, "0")
  end

  @doc """
  Format timezone.
  """
  def format_timezone(tz) do
    {hours, minutes, _, _} = Timex.Duration.from_hours(tz.offset)
    |> Timex.Duration.to_clock()

    prefix = if hours >= 0, do: "+", else: "-"
    hours = pad(hours)
    minutes = pad(minutes)
    "(UTC#{prefix}#{hours}:#{minutes}) " <> String.replace(String.replace(tz.name, "/", ", "), "_", " ")
  end

  @doc """
  """
  def relative_diff_date(sent_email_date, read_email_date, locale) do
    duration = Timex.diff(read_email_date, sent_email_date, :duration)
    Timex.Format.Duration.Formatter.lformat(duration, locale, :humanized)
  end

  @doc """
  Format list, which the return from `Tzdata.canonical_zone_list/0`
  """
  def format_canonical_zone_list(list) do
    list
    |> Enum.map(fn tz -> %{name: tz, offset: get_timezone_offset_by_name(tz)} end)
    |> Enum.map(fn tz -> %{id: tz.name, text: format_timezone(tz), offset: tz.offset} end)
  end

  @doc """
  Convert time to need timezone and format.
  """
  def format_time_l(time_string, timezone) do
    Timex.format!(Timex.Timezone.convert(time_string, timezone), gettext("%Y-%m-%d at %H:%M"), :strftime)
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
end
