defmodule MyAppWeb.EventsResolver do
  alias MyApp.Content

  def all_events(_root, _args, _info) do
    events = Content.list_events()
    {:ok, events}
  end

  def list_events_confirmed_by_user(root, _args, _info) do
    events = Content.list_events_confirmed(root)
    {:ok, events}
  end

  def find_event(%{id: id}, _info) do
    case Content.get_event!(id) do
      nil -> {:error, "Event id #{id} not found!"}
      event -> {:ok, event}
    end
  end

  def find_event_by_confirmation(%{event_id: id}, _args, _info) do
    case Content.get_event!(id) do
      nil -> {:error, "Event id #{id} not found!"}
      event -> {:ok, event}
    end
  end

  def list_events_by_author_id(root, _args, _info) do
    events = Content.list_events_by_author_id(root.id)
    {:ok, events}
  end

  def create_event(_root, args, _info) do
    case Content.create_event(args) do
      {:ok, event} ->
        MyAppWeb.ConfirmationsResolver.create_confirmation(
          nil,
          %{"user_id" => event.user_id, "event_id" => event.id},
          nil
        )

        {:ok, event}

      {:error, changeset} ->
        case changeset.errors[:user_id] do
          error ->
            {error, _} = changeset.errors[:user_id]
            {:error, error <> ", Event not created"}

          nil ->
            {:error, "blank value got, Event not created"}
        end
    end
  end
end
