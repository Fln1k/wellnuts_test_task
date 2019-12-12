defmodule MyAppWeb.PageController do
  use MyAppWeb, :controller

  alias MyApp.Contents
  alias MyAppWeb.Guardian

  def index(conn, _params) do
    conn
    |> assign(:events, Contents.list_events())
    |> assign(:current_user, Guardian.Plug.current_resource(conn))
    |> render("index.html")
  end
end
