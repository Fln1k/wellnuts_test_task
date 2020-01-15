defmodule MyAppWeb.ConfirmationController do
  use MyAppWeb, :controller
  import Ecto.Query, warn: false
  alias MyApp.Repo
  alias MyApp.Content.Confirmation

  def create(conn, params) do
    case from(c in Confirmation,
           where:
             c.event_id == ^params["event_id"] and
               c.user_id == ^params["user_id"],
           select: c.event_id
         )
         |> Repo.one() do
      nil ->
        case MyApp.Content.create_confirmation(params) do
          {:ok, _confirmation} ->
            conn
            |> put_flash(:info, "Confirmed successfully.")
            |> redirect(to: "/")

          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "/", changeset: changeset)
        end

      confirmation ->
        conn
        |> put_flash(:error, "You already confirm")
        |> redirect(to: "/")
    end
  end
end
