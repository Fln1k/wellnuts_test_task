defmodule MyAppWeb.ConfirmationController do
  use MyAppWeb, :controller
  import Ecto.Query, warn: false
  alias MyApp.Repo
  alias MyApp.Content.Confirmation

  def create(conn, params) do
    case MyApp.Content.create_confirmation(params) do
      {:ok, _confirmation} ->
        conn
        |> put_flash(:info, "Confirmed successfully.")
        |> redirect(to: "/")

      {:error, _} ->
        conn
        |> put_flash(:error, "You already confirm")
        |> redirect(to: "/")
    end
  end
end
