defmodule MyAppWeb.EventController do
  use MyAppWeb, :controller
  alias MyApp.Content
  alias MyApp.Content.Event
  alias MyApp.Content
  require Logger

  plug(:author_check when action in [:edit, :update])

  def new(conn, _params) do
    changeset = Content.change_event(%Event{})

    render(conn, "new.html",
      changeset: %{changeset | errors: []},
      current_user: Guardian.Plug.current_resource(conn)
    )
  end

  def create(conn, %{"event" => event_params}) do
    case Content.create_event(
           Map.put(event_params, "user_id", Guardian.Plug.current_resource(conn).id)
         ) do
      {:ok, event} ->
        Content.create_confirmation(%{
          "user_id" => Guardian.Plug.current_resource(conn).id,
          "event_id" => event.id
        })

        conn
        |> put_flash(:info, "Event was created")
        |> redirect(to: "/")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    event = Content.get_event!(id)

    render(conn, "show.html",
      event: event,
      current_user: Guardian.Plug.current_resource(conn),
      user_email_list: Content.user_email_list_by_event_id(event.id)
    )
  end

  def edit(conn, %{"id" => id}) do
    event = Content.get_event!(id)

    render(conn, "edit.html",
      event: event,
      changeset: Content.change_event(event),
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
          changeset: changeset
        )
    end
  end

  def author_check(conn, _params) do
    if Guardian.Plug.current_resource(conn).id ==
         Content.get_event!(conn.path_params["id"]).user_id do
      conn
    else
      conn
      |> put_flash(:error, "Denied")
      |> redirect(to: "/")
    end
  end
end
