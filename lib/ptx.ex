defmodule Ptx do
  @moduledoc """
  Ptx keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

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
end
