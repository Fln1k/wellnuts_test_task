defmodule MyAppWeb.EventsResolver do
  alias MyApp.Event

  def all_events(_root, _args, _info) do
    events = MyApp.Content.list_events_api()
    {:ok, events}
  end

  def event_confirmed_users_email_list(_root, _args, _info) do
    users = MyApp.Content.user_list_by_event_id(_root.id)
    {:ok, users}
  end
end
