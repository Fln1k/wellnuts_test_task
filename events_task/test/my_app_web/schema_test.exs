defmodule MyApp.SchemaTest do
  use MyAppWeb.ConnCase
  alias MyApp.Accounts
  alias MyApp.Content

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
      |> Enum.into(%{
        "description" => "ShemaTest",
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

  test "successfully query: create_user with valid params", %{conn: conn} do
    conn =
      post(conn, "/api", %{
        "query" => """
        mutation{
        createUser(email: "sometestmail@example.com")
        {
          email
        }
        }
        """
      })

    assert json_response(conn, 200) == %{
             "data" => %{"createUser" => %{"email" => "sometestmail@example.com"}}
           }
  end

  test "fails query: create_user with invalid params", %{conn: conn} do
    conn =
      post(conn, "/api", %{
        "query" => """
        mutation{
        createUser(email: "")
        {
          email
        }
        }
        """
      })

    assert json_response(conn, 200) == %{
             "data" => %{"createUser" => nil},
             "errors" => [
               %{
                 "locations" => [%{"column" => 0, "line" => 2}],
                 "message" => "User not created",
                 "path" => ["createUser"]
               }
             ]
           }
  end

  test "successfully query: get user by email", %{conn: conn} do
    user = create_test_user()

    conn =
      post(conn, "/api", %{
        "query" => """
        query{
        getUser(email: "#{user.email}")
        {
          email
        }
        }
        """
      })

    assert json_response(conn, 200) == %{
             "data" => %{"getUser" => %{"email" => user.email}}
           }
  end

  test "successfully query: get user by id", %{conn: conn} do
    user = create_test_user()

    conn =
      post(conn, "/api", %{
        "query" => """
        query{
        getUser(id: "#{user.id}")
        {
          email
        }
        }
        """
      })

    assert json_response(conn, 200) == %{
             "data" => %{"getUser" => %{"email" => user.email}}
           }
  end

  test "successfully query: get user by id and email", %{conn: conn} do
    user = create_test_user()

    conn =
      post(conn, "/api", %{
        "query" => """
        query{
        getUser(id: "#{user.id}", email: "#{user.email}")
        {
          email
        }
        }
        """
      })

    assert json_response(conn, 200) == %{
             "data" => %{"getUser" => %{"email" => user.email}}
           }
  end

  test "fails query: get user by invalid id and valid email", %{conn: conn} do
    user = create_test_user()

    conn =
      post(conn, "/api", %{
        "query" => """
        query{
        getUser(id: "-1", email: "#{user.email}")
        {
          email
        }
        }
        """
      })

    assert json_response(conn, 200) == %{
             "data" => %{"getUser" => nil}
           }
  end

  test "fails query: get user by valid id and invalid email", %{conn: conn} do
    user = create_test_user()

    conn =
      post(conn, "/api", %{
        "query" => """
        query{
        getUser(id: "#{user.id}", email: "someinvalidemail@example.com")
        {
          email
        }
        }
        """
      })

    assert json_response(conn, 200) == %{
             "data" => %{"getUser" => nil}
           }
  end

  test "successfully query: get users", %{conn: conn} do
    user_1 = create_test_user()
    user_2 = create_test_user(%{:email => "someother@example.com"})

    conn =
      post(conn, "/api", %{
        "query" => """
        query{
        getUsers
        {
          email
        }
        }
        """
      })

    assert json_response(conn, 200) == %{
             "data" => %{
               "getUsers" => [%{"email" => user_1.email}, %{"email" => user_2.email}]
             }
           }
  end

  test "successfully query: create_event with valid params", %{conn: conn} do
    user = create_test_user()

    conn =
      post(conn, "/api", %{
        "query" => """
        mutation{
        createEvent(description: "ShemaTestEvent" timestamp: "2015-01-01T00:00:00.000000" userId: #{
          user.id
        })
        {
        user_id
        }
        }
        """
      })

    assert json_response(conn, 200) == %{
             "data" => %{"createEvent" => %{"user_id" => "#{user.id}"}}
           }
  end

  test "fails query: create_event with invalid params", %{conn: conn} do
    user = create_test_user()

    conn =
      post(conn, "/api", %{
        "query" => """
        mutation{
        createEvent(description: "" timestamp: "2015-01-01T00:00:00.000000" userId: #{user.id})
        {
        user_id
        }
        }
        """
      })

    assert json_response(conn, 200) == %{
             "data" => %{"createEvent" => nil},
             "errors" => [
               %{
                 "locations" => [%{"column" => 0, "line" => 2}],
                 "path" => ["createEvent"],
                 "message" => "can't be blank, Confirmation not created"
               }
             ]
           }
  end

  test "successfully query: get event", %{conn: conn} do
    user = create_test_user()
    event = create_test_event(%{"user_id" => user.id})

    conn =
      post(conn, "/api", %{
        "query" => """
        query{
        getEvent(id: #{event.id}){
        id
        }
        }


        """
      })

    assert json_response(conn, 200) == %{"data" => %{"getEvent" => %{"id" => "#{event.id}"}}}
  end

  test "successfully query: get events", %{conn: conn} do
    user = create_test_user()
    event_1 = create_test_event(%{"user_id" => user.id})
    event_2 = create_test_event(%{"user_id" => user.id})

    conn =
      post(conn, "/api", %{
        "query" => """
        query{
        getEvents{
        id
        }
        }


        """
      })

    assert json_response(conn, 200) == %{
             "data" => %{"getEvents" => [%{"id" => "#{event_1.id}"}, %{"id" => "#{event_2.id}"}]}
           }
  end

  test "successfully query: creaete confirmation with valid params", %{conn: conn} do
    user = create_test_user()
    event = create_test_event(%{"user_id" => user.id})

    conn =
      post(conn, "/api", %{
        "query" => """
        mutation{
        createConfirmation(eventId: #{event.id},userId:#{event.user_id})
        {
          eventId
          userId
        }
        }


        """
      })

    assert json_response(conn, 200) == %{
             "data" => %{
               "createConfirmation" => %{"eventId" => "#{event.id}", "userId" => "#{user.id}"}
             }
           }
  end

  test "successfully query: automagicaly creates confirmation for event creator",
       %{conn: conn} do
    user = create_test_user()

    conn =
      post(conn, "/api", %{
        "query" => """
        mutation{
        createEvent(description: "ShemaTestEvent" timestamp: "2015-01-01T00:00:00.000000" userId: #{
          user.id
        })
        {
        id
        }
        }
        """
      })

    event_id = json_response(conn, 200)["data"]["createEvent"]["id"]

    conn =
      post(conn, "/api", %{
        "query" => """
        query{
        getUser(id: #{user.id})
        {
        confirmations{
        eventId
        }
        }
        }
        """
      })

    assert Enum.member?(json_response(conn, 200)["data"]["getUser"]["confirmations"], %{
             "eventId" => "#{event_id}"
           })
  end

  test "successfully query: get user with list created events, list confirmed events and list confirmations",
       %{conn: conn} do
    user = create_test_user()

    conn =
      post(conn, "/api", %{
        "query" => """
        mutation{
        createEvent(description: "ShemaTestEvent1" timestamp: "2015-01-01T00:00:00.000000" userId: #{
          user.id
        })
        {
        id
        description
        }
        }
        """
      })

    event_1_info = json_response(conn, 200)["data"]["createEvent"]

    conn =
      post(conn, "/api", %{
        "query" => """
        mutation{
        createEvent(description: "ShemaTestEvent2" timestamp: "2015-01-01T00:00:00.000000" userId: #{
          user.id
        })
        {
        id
        description
        }
        }
        """
      })

    event_2_info = json_response(conn, 200)["data"]["createEvent"]

    conn =
      post(conn, "/api", %{
        "query" => """
        query{
        getUser(id: #{user.id})
        {
        id
        createdEvents{
        id
        userId
        }
        confirmations{
        userId
        eventId
        }
        eventsConfirmed{
        id
        }
        }
        }

        """
      })

    assert json_response(conn, 200) == %{
             "data" => %{
               "getUser" => %{
                 "confirmations" => [
                   %{"eventId" => "#{event_1_info["id"]}", "userId" => "#{user.id}"},
                   %{"eventId" => "#{event_2_info["id"]}", "userId" => "#{user.id}"}
                 ],
                 "createdEvents" => [
                   %{"id" => "#{event_2_info["id"]}", "userId" => "#{user.id}"},
                   %{"id" => "#{event_1_info["id"]}", "userId" => "#{user.id}"}
                 ],
                 "eventsConfirmed" => [
                   %{"id" => "#{event_1_info["id"]}"},
                   %{"id" => "#{event_2_info["id"]}"}
                 ],
                 "id" => "#{user.id}"
               }
             }
           }
  end

  test "successfully query: get event with author, list confirmed users and list confirmations",
       %{conn: conn} do
    user = create_test_user()

    conn =
      post(conn, "/api", %{
        "query" => """
        mutation{
        createEvent(description: "ShemaTestEvent1" timestamp: "2015-01-01T00:00:00.000000" userId: #{
          user.id
        })
        {
        id
        confirmations{
        id
        }
        }
        }
        """
      })

    event_info = json_response(conn, 200)["data"]["createEvent"]

    conn =
      post(conn, "/api", %{
        "query" => """
        query{
        getConfirmation(id:#{Enum.at(event_info["confirmations"], 0)["id"]})
        {
          id
        event{
        id
        }
        user
        {
        id
        }
        }
        }


        """
      })

    assert json_response(conn, 200) == %{
             "data" => %{
               "getConfirmation" => %{
                 "event" => %{"id" => "#{event_info["id"]}"},
                 "user" => %{"id" => "#{user.id}"},
                 "id" => "#{Enum.at(event_info["confirmations"], 0)["id"]}"
               }
             }
           }
  end

  test "fails query: create 2 confirmations with same params", %{conn: conn} do
    user = create_test_user()
    event = create_test_event(%{"user_id" => user.id})

    conn =
      post(conn, "/api", %{
        "query" => """
        mutation{
        createConfirmation(eventId: #{event.id},userId:#{event.user_id})
        {
          eventId
          userId
        }
        }


        """
      })

    assert json_response(conn, 200) == %{
             "data" => %{
               "createConfirmation" => %{"eventId" => "#{event.id}", "userId" => "#{user.id}"}
             }
           }

    conn =
      post(conn, "/api", %{
        "query" => """
        mutation{
        createConfirmation(eventId: #{event.id},userId:#{event.user_id})
        {
          eventId
          userId
        }
        }


        """
      })

    assert json_response(conn, 200) == %{
             "data" => %{"createConfirmation" => nil},
             "errors" => [
               %{
                 "locations" => [%{"column" => 0, "line" => 2}],
                 "message" => "has already been taken, Confirmation not created",
                 "path" => ["createConfirmation"]
               }
             ]
           }
  end

  test "fails query: create event with invalid user_id param", %{conn: conn} do
    conn =
      post(conn, "/api", %{
        "query" => """
        mutation{
        createEvent(description: "sad" timestamp: "2015-01-01T00:00:00.000000" userId: -1)
        {
        user_id
        }
        }
        """
      })

    assert json_response(conn, 200) == %{
             "data" => %{"createEvent" => nil},
             "errors" => [
               %{
                 "locations" => [%{"column" => 0, "line" => 2}],
                 "message" => "User don't exist, Confirmation not created",
                 "path" => ["createEvent"]
               }
             ]
           }
  end

  test "fails query: creaete confirmation with invalid user_id param", %{conn: conn} do
    user = create_test_user()
    event = create_test_event(%{"user_id" => user.id})

    conn =
      post(conn, "/api", %{
        "query" => """
        mutation{
        createConfirmation(eventId: #{event.id},userId: -1)
        {
          eventId
          userId
        }
        }


        """
      })

    assert json_response(conn, 200) == %{
             "data" => %{"createConfirmation" => nil},
             "errors" => [
               %{
                 "locations" => [%{"column" => 0, "line" => 2}],
                 "message" => "User don't exist, Confirmation not created",
                 "path" => ["createConfirmation"]
               }
             ]
           }
  end

  test "fails query: creaete confirmation with invalid event_id param", %{conn: conn} do
    user = create_test_user()
    event = create_test_event(%{"user_id" => user.id})

    conn =
      post(conn, "/api", %{
        "query" => """
        mutation{
        createConfirmation(eventId: -1,userId: #{event.user_id})
        {
          eventId
          userId
        }
        }


        """
      })

    assert json_response(conn, 200) == %{
             "data" => %{"createConfirmation" => nil},
             "errors" => [
               %{
                 "locations" => [%{"column" => 0, "line" => 2}],
                 "message" => "Event don't exist, Confirmation not created",
                 "path" => ["createConfirmation"]
               }
             ]
           }
  end
end
