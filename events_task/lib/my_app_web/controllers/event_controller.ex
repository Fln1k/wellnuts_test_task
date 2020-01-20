defmodule MyAppWeb.EventController do
  use MyAppWeb, :controller
  alias MyApp.Content
  alias MyApp.Content.Event
  alias MyApp.Content
  require Logger

  plug(:authenticated when action in [:new, :create, :edit, :update])
  plug(:get_event when action in [:edit, :update, :show])
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
        |> redirect(to: event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, params) do
    event = conn.assigns[:event]

    render(conn, "show.html",
      event: event,
      current_user: Guardian.Plug.current_resource(conn),
      user_list: Content.user_list_by_event_id(event.id)
    )
  end

  def edit(conn, %{"id" => id}) do
    event = conn.assigns[:event]

    render(conn, "edit.html",
      event: event,
      changeset: Content.change_event(event),
      current_user: Guardian.Plug.current_resource(conn)
    )
  end

  def update(conn, params) do
    event = conn.assigns[:event]

    case Content.update_event(event, params["event"]) do
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
         conn.assigns[:event].user_id do
      conn
    else
      conn
      |> put_flash(:error, "Denied")
      |> redirect(to: page_path(conn, :index))
      |> halt
    end
  end

  def authenticated(conn, _params) do
    if Guardian.Plug.current_resource(conn) do
      conn
    else
      conn
      |> put_flash(:error, "Denied")
      |> redirect(to: page_path(conn, :index))
      |> halt
    end
  end

  def get_event(conn, _params) do
    conn = assign(conn, :event, Content.get_event!(conn.path_params["id"]))
  end
end
