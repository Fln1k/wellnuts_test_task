defmodule MyAppWeb.ConfirmationController do
  use MyAppWeb, :controller
  import Ecto.Query, warn: false
  alias MyApp.Repo

  alias MyApp.UserEventConfirmation.Confirmation

  def create(conn, confirmation_params) do
    case from(c in Confirmation,
           where:
             c.event_id == ^confirmation_params["event_id"] and
               c.user_id == ^confirmation_params["user_id"],
           select: c.event_id
         )
         |> Repo.one() do
      nil ->
        case MyApp.UserEventConfirmation.create_confirmation(confirmation_params) do
          {:ok, _confirmation} ->
            conn
            |> put_flash(:info, "Confirmed successfully.")
            |> redirect(to: "/")

          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "/", changeset: changeset)
        end

      confirmation ->
        conn
        |> put_flash(:error, "You already confirme")
        |> redirect(to: "/")
    end
  end
end
