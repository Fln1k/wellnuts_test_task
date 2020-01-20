defmodule Absinthe.Type.Custom do
  use Absinthe.Schema.Notation

  scalar :naive_datetime, name: "NaiveDateTime" do
    description("""
    The `Naive DateTime` scalar type represents a naive date and time without
    timezone. The DateTime appears in a JSON response as an ISO8601 formatted
    string.
    """)

    serialize(&NaiveDateTime.to_iso8601/1)
    parse(&parse_naive_datetime/1)
  end

  @spec parse_naive_datetime(Absinthe.Blueprint.Input.String.t()) ::
          {:ok, NaiveDateTime.t()} | :error
  @spec parse_naive_datetime(Absinthe.Blueprint.Input.Null.t()) :: {:ok, nil}
  defp parse_naive_datetime(%Absinthe.Blueprint.Input.String{value: value}) do
    case NaiveDateTime.from_iso8601(value) do
      {:ok, naive_datetime} -> {:ok, naive_datetime}
      _error -> :error
    end
  end

  defp parse_naive_datetime(%Absinthe.Blueprint.Input.Null{}) do
    {:ok, nil}
  end

  defp parse_naive_datetime(_) do
    :error
  end
end
