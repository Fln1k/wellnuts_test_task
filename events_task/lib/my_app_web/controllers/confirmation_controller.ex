defmodule MyAppWeb.ConfirmationController do
  use MyAppWeb, :controller

  alias MyApp.UserEventConfirmation
  alias MyApp.UserEventConfirmation.Confirmation

  def create(conn, confirmation_params) do
    case UserEventConfirmation.create_confirmation(confirmation_params) do
      {:ok, confirmation} ->
        conn
        |> put_flash(:info, "Confirmed successfully.")
        |> redirect(to: "/")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "/", changeset: changeset)
    end
  end
end
