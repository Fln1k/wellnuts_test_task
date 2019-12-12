defmodule MyAppWeb.EventController do
  use MyAppWeb, :controller

  alias MyApp.Content
  alias MyApp.Content.Event

  def index(conn, _params) do
    events = Content.list_events()
    render(conn, "index.html", events: events)
  end

  def new(conn, _params) do
    changeset = Content.change_event(%Event{})

    render(conn, "new.html",
      changeset: changeset,
      current_user: Guardian.Plug.current_resource(conn)
    )
  end

  def create(conn, %{"event" => event_params}) do
    case Content.create_event(event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html",
          changeset: changeset,
          current_user: Guardian.Plug.current_resource(conn)
        )
    end
  end

  def show(conn, %{"id" => id}) do
    event = Content.get_event!(id)

    render(conn, "show.html",
      event: event,
      current_user: Guardian.Plug.current_resource(conn)
    )
  end

  def edit(conn, %{"id" => id}) do
    event = Content.get_event!(id)
    changeset = Content.change_event(event)

    render(conn, "edit.html",
      event: event,
      changeset: changeset,
      current_user: Guardian.Plug.current_resource(conn)
    )
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = Content.get_event!(id)

    case Content.update_event(event, event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event updated successfully.")
        |> redirect(to: event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html",
          event: event,
          changeset: changeset,
          current_user: Guardian.Plug.current_resource(conn)
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    event = Content.get_event!(id)
    {:ok, _event} = Content.delete_event(event)

    conn
    |> put_flash(:info, "Event deleted successfully.")
    |> redirect(to: event_path(conn, :index))
  end
end
