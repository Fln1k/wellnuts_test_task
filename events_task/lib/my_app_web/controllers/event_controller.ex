defmodule MyAppWeb.EventController do
  use MyAppWeb, :controller
  alias MyApp.Content
  alias MyApp.Content.Event
  alias MyApp.UserEventConfirmation

  plug(:check_author when action in [:edit])

  def new(conn, _params) do
    changeset = Content.change_event(%Event{})

    render(conn, "new.html",
      changeset: changeset,
      current_user: Guardian.Plug.current_resource(conn)
    )
  end

  def create(conn, %{"event" => event_params}) do
    case Content.create_event(
           Map.put(event_params, "user_id", Guardian.Plug.current_resource(conn).id)
         ) do
      {:ok, event} ->
        conn
        |> redirect(
          to:
            confirmation_path(
              conn,
              :create,
              %{
                "user_id" => Guardian.Plug.current_resource(conn).id,
                "event_id" => event.id
              }
            )
        )

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    event = Content.get_event!(id)

    render(conn, "show.html",
      event: event,
      current_user: Guardian.Plug.current_resource(conn),
      user_email_list: UserEventConfirmation.user_email_list_by_event_id(event.id)
    )
  end

  def edit(conn, %{"id" => id}) do
    event = Content.get_event!(id)
    changeset = Content.change_event(event)
    current_user = Guardian.Plug.current_resource(conn)

    if event.user_id == current_user.id do
      render(conn, "edit.html",
        event: event,
        changeset: changeset,
        current_user: current_user
      )
    else
      conn
      |> put_flash(:error, "No access to this action.")
      |> redirect(to: "/")
    end
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

  defp check_author(conn, _params) do
    conn
  end
end
