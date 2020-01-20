defmodule MyApp.PageControllerTest do
  use MyAppWeb.ConnCase
  alias MyApp.Content
  alias MyApp.Accounts
  alias MyAppWeb.Guardian

  describe "page" do
    def create_test_event(attrs \\ %{}) do
      {:ok, event} =
        attrs
        |> Enum.into(%{
          "description" => "TestText",
          "timestamp" => %{
            "day" => "1",
            "hour" => "0",
            "minute" => "0",
            "month" => "1",
            "year" => "2015"
          }
        })
        |> Content.create_event()

      event
    end

    def create_test_user(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(%{email: "sergei@example.com"})
        |> Accounts.create_user()

      user
    end

    test "successfully open index.html and check confirmation" do
      event = create_test_event()
      user = create_test_user()
      Content.Event.confirm_event(%{"event_id" => event.id, "user_id" => user.id})

      conn =
        build_conn()
        |> Guardian.Plug.sign_in(user)
        |> get(page_path(conn, :index))

      assert conn.assigns[:current_user_confirmations] == [event.id]
    end
  end
end
