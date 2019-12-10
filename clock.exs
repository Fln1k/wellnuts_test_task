defmodule Clocks do
  def new(hours, minutes) do
    {additional_hours, minutes} = check_minutes(minutes)
    %{hour: check_hours(hours + additional_hours), minute: minutes}
  end

  def add_minutes(clock, additional_minutes) do
    new(clock.hour, clock.minute + additional_minutes)
  end

  def check_hours(hours) when hours < 0, do: 24 + rem(hours, 24)
  def check_hours(hours) when hours >= 24, do: rem(hours, 24)
  def check_hours(hours), do: hours

  def check_minutes(minutes) when minutes < 0, do: {div(minutes, 60) - 1, 60 + rem(minutes, 60)}
  def check_minutes(minutes) when minutes >= 60, do: {div(minutes, 60), rem(minutes, 60)}
  def check_minutes(minutes), do: {0, minutes}

  def print(clock) do
   IO.inspect covert(clock.hour)<>":"<>covert(clock.minute)
  end

  def covert(value) do
    value |> Integer.to_string |> String.pad_leading(2, "0")
  end

end

Clocks.new(4, 65) |> Clocks.print