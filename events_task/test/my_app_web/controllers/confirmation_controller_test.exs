defmodule MyApp.ConfirmationControllerTest do
  use MyAppWeb.ConnCase
  alias MyApp.Accounts
  alias MyApp.Content

  @valid_event_attrs %{
    "description" => "TestText",
    "timestamp" => %{
      "day" => "1",
      "hour" => "0",
      "minute" => "0",
      "month" => "1",
      "year" => "2015"
    }
  }

  describe "confirmations" do
    def create_test_user(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(%{email: "sergei@gmail.com"})
        |> Accounts.create_user()

      user
    end

    def create_test_event(attrs \\ %{}) do
      {:ok, event} =
        attrs
        |> Enum.into(@valid_event_attrs)
        |> Content.create_event()

      event
    end

    test "create confirmation with valid params" do
      event = create_test_event()
      user = create_test_user()

      conn =
        build_conn()
        |> post(confirmation_path(conn, :create, %{"event_id" => event.id, "user_id" => user.id}))

      assert conn.private[:plug_session]["phoenix_flash"] == %{
               "info" => "Confirmed successfully."
             }
    end

    test "double confirmation" do
      event = create_test_event()
      user = create_test_user()

      conn =
        build_conn()
        |> post(confirmation_path(conn, :create, %{"event_id" => event.id, "user_id" => user.id}))

      assert conn.private[:plug_session]["phoenix_flash"] == %{
               "info" => "Confirmed successfully."
             }

      conn =
        post(
          conn,
          confirmation_path(conn, :create, %{"event_id" => event.id, "user_id" => user.id})
        )

      assert conn.private[:plug_session]["phoenix_flash"] == %{
               "error" => "You already confirm",
               "info" => "Confirmed successfully."
             }
    end
  end
end
