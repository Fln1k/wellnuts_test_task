defmodule MyAppWeb.PageController do
  use MyAppWeb, :controller

  alias MyApp.Content
  alias MyApp.UserEventConfirmation
  alias MyAppWeb.Guardian
  alias MyApp.Accounts

  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)

    conn
    |> assign(:events, Content.list_events())
    |> assign(:current_user, current_user)
    |> assign(:current_user_confirmations, UserEventConfirmation.user_list_events(current_user))
    |> assign(:changeset, Accounts.change_user(%{:email => current_user.email}))
    |> render("index.html")
  end
end
