defmodule MyAppWeb.PageController do
  use MyAppWeb, :controller
  alias MyApp.Content
  alias MyApp.Content
  alias MyAppWeb.Guardian
  alias MyApp.Accounts

  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)

    changeset =
      if current_user do
        Accounts.change_user(%{:email => current_user.email})
      else
        :error
      end

    conn
    |> assign(:events, Content.list_events())
    |> assign(:current_user, current_user)
    |> assign(
      :current_user_confirmations,
      Content.list_events_confirmed(current_user) |> Enum.map(& &1.id)
    )
    |> assign(:changeset, changeset)
    |> render("index.html")
  end
end
