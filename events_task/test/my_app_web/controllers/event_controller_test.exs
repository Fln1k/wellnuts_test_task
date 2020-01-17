defmodule MyApp.EventControllerTest do
  use MyAppWeb.ConnCase

  alias MyApp.Accounts
  alias MyAppWeb.Guardian
  alias MyApp.Content

  @valid_attrs %{
    "description" => "TestText",
    "timestamp" => %{
      "day" => "1",
      "hour" => "0",
      "minute" => "0",
      "month" => "1",
      "year" => "2015"
    }
  }
  @invalid_attrs %{
    "description" => "",
    "timestamp" => %{
      "day" => "1",
      "hour" => "0",
      "minute" => "0",
      "month" => "1",
      "year" => "2015"
    }
  }
  describe "events" do
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
        |> Enum.into(@valid_attrs)
        |> Content.create_event()

      event
    end

    test "new event page" do
      conn = get(build_conn(), event_path(build_conn(), :new))
      assert conn.path_info == ["events", "new"]
    end

    test "event creation with valid params" do
      conn =
        build_conn()
        |> Guardian.Plug.sign_in(create_test_user())
        |> post(event_path(build_conn(), :create, %{"event" => @valid_attrs}))

      assert redirected_to(conn) =~ "/events/"
    end

    test "event creation with invalid params" do
      conn =
        build_conn()
        |> Guardian.Plug.sign_in(create_test_user())
        |> post(
          event_path(build_conn(), :create, %{
            "event" => @invalid_attrs
          })
        )

      assert response(conn, 200) =~ "Oops, something went wrong! Please check the errors below."
    end

    test "show event" do
      event = create_test_event()

      conn =
        build_conn()
        |> Guardian.Plug.sign_in(create_test_user())
        |> get(event_path(build_conn(), :show, event.id))

      assert response(conn, 200) =~ "<strong>Description:</strong>\n" <> event.description
    end

    test "edit event with not author user" do
      user = create_test_user()
      conn = build_conn()

      id =
        conn
        |> Guardian.Plug.sign_in(user)
        |> post(event_path(conn, :create, %{"event" => @valid_attrs}))
        |> redirected_to()
        |> String.slice(8..-1)

      conn =
        build_conn()
        |> Guardian.Plug.sign_in(create_test_user(%{email: "sergeis@gmail.com"}))
        |> put(
          event_path(
            conn,
            :update,
            struct(MyApp.Content.Event, %{
              description: "UpdatedTestText",
              id: id,
              timestamp: %{
                "day" => 1,
                "hour" => "0",
                "minute" => "0",
                "month" => "1",
                "year" => "2020"
              }
            })
          )
        )

      assert redirected_to(conn) == page_path(conn, :index)
    end

    conn

    test "edit event with invalid user" do
      conn = build_conn() |> Guardian.Plug.sign_in(create_test_user())

      id =
        conn
        |> post(event_path(conn, :create, %{"event" => @valid_attrs}))
        |> redirected_to()
        |> String.slice(8..-1)

      conn =
        build_conn()
        |> Guardian.Plug.sign_in(create_test_user(%{email: "sergeis@gmail.com"}))
        |> put(
          event_path(
            conn,
            :update,
            struct(MyApp.Content.Event, %{
              description: "UpdatedTestText",
              id: id,
              timestamp: %{
                "day" => 1,
                "hour" => "0",
                "minute" => "0",
                "month" => "1",
                "year" => "2020"
              }
            })
          )
        )

      assert redirected_to(conn) == page_path(conn, :index)
    end

    test "edit event with unauthenticated user" do
      conn = build_conn() |> Guardian.Plug.sign_in(create_test_user())

      id =
        conn
        |> post(event_path(conn, :create, %{"event" => @valid_attrs}))
        |> redirected_to()
        |> String.slice(8..-1)

      conn =
        build_conn()
        |> put(
          event_path(
            conn,
            :update,
            struct(MyApp.Content.Event, %{
              description: "UpdatedTestText",
              id: id,
              timestamp: %{
                "day" => "1",
                "hour" => "0",
                "minute" => "0",
                "month" => "1",
                "year" => "2020"
              }
            })
          )
        )

      assert redirected_to(conn) == page_path(conn, :index)
    end

    test "edit event with valid params" do
      conn = build_conn() |> Guardian.Plug.sign_in(create_test_user())

      id =
        conn
        |> post(event_path(conn, :create, %{"event" => @valid_attrs}))
        |> redirected_to()
        |> String.slice(8..-1)

      response =
        conn
        |> put(
          event_path(
            conn,
            :update,
            id,
            %{
              "event" => %{
                "description" => "UpdatedTestText",
                "timestamp" => %{
                  "day" => "1",
                  "hour" => "0",
                  "minute" => "0",
                  "month" => "1",
                  "year" => "2015"
                }
              }
            }
          )
        )
        |> get(event_path(conn, :show, id))
        |> response(200)

      assert response =~ "<strong>Description:</strong>\nUpdatedTestText"
    end
  end
end
