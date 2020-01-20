defmodule MyAppWeb.EventsResolver do
  alias MyApp.Event

  def all_events(_root, _args, _info) do
    events = MyApp.Content.list_events()
    {:ok, events}
  end
end
