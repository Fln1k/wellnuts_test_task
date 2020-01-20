defmodule MyAppWeb.EventsResolver do
  def all_events(_root, _args, _info) do
    events = MyApp.Content.list_events_api()
    {:ok, events}
  end

  def event_confirmed_users_list_by_event_id(_root, _args, _info) do
    users = MyApp.Content.user_list_by_event_id(_root.id)
    {:ok, users}
  end

  def event_confirmations_list_by_event_id(_root, _args, _info) do
    confirmations = MyApp.Content.event_confirmations_list(_root.id)
    {:ok, confirmations}
  end

  def find_event(%{id: id}, _info) do
    case MyApp.Content.get_event_api(id) do
      nil -> {:error, "Event id #{id} not found!"}
      event -> {:ok, event}
    end
  end
end
