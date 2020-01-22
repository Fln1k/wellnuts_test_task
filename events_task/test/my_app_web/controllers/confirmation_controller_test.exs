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
        |> Enum.into(%{email: "sergei@example.com"})
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

    test "successfully create confirmation with valid params" do
      event = create_test_event()
      user = create_test_user()

      conn =
        build_conn()
        |> post(confirmation_path(conn, :create, %{"event_id" => event.id, "user_id" => user.id}))

      assert get_flash(conn, :error) == nil
    end

    test "fails double confirmation" do
      event = create_test_event()
      user = create_test_user()

      conn =
        build_conn()
        |> post(confirmation_path(conn, :create, %{"event_id" => event.id, "user_id" => user.id}))

      assert get_flash(conn, :error) == nil

      conn =
        post(
          conn,
          confirmation_path(conn, :create, %{"event_id" => event.id, "user_id" => user.id})
        )

      assert get_flash(conn, :error) != nil
    end
  end
end
