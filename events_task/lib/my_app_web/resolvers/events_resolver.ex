defmodule MyAppWeb.EventsResolver do
  def all_events(_root, _args, _info) do
    events = MyApp.Content.list_events()
    {:ok, events}
  end

  def list_events_confirmed_by_user(_root, _args, _info) do
    events = MyApp.Content.list_events_confirmed(_root)
    {:ok, events}
  end

  def find_event(%{id: id}, _info) do
    case MyApp.Content.get_event!(id) do
      nil -> {:error, "Event id #{id} not found!"}
      event -> {:ok, event}
    end
  end

  def find_event_by_confirmation(%{event_id: id}, _info) do
    case MyApp.Content.get_event!(id) do
      nil -> {:error, "Event id #{id} not found!"}
      event -> {:ok, event}
    end
  end

  def list_events_by_author_id(_root, _args, _info) do
    events = MyApp.Content.list_events_by_author_id(_root.id)
    {:ok, events}
  end
end
