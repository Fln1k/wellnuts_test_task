defmodule MyApp.ContentTest do
  use MyApp.DataCase
  alias MyApp.Content
  alias MyApp.Accounts

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

  def create_test_event(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Content.create_event()

    event
  end

  def create_test_user(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{email: "sergei@gmail.com"})
      |> Accounts.create_user()

    user
  end

  describe "content" do
    test "successfully create event with valid_attrs" do
      assert {:ok, %Content.Event{} = event} = Content.create_event(@valid_attrs)
      assert event.description == "TestText"
    end

    test "fails create event with invalid_attrs" do
      assert {:error, _} = Content.create_event(@invalid_attrs)
    end

    test "successfully get event" do
      event = create_test_event()
      assert Content.get_event!(event.id).id == event.id
    end

    test "successfully update event with valid params" do
      event = create_test_event()
      Content.update_event(event, %{"description" => "asd"})
      Content.get_event!(event.id).description == "asd"
    end

    test "successfully delete event" do
      event = create_test_event()
      assert {:ok, _} = Content.delete_event(event)
    end

    test "fails update event with invalid params" do
      event = create_test_event()
      Content.update_event(event, %{"description" => ""})
      Content.get_event!(event.id).description == @valid_attrs["description"]
    end

    test "successfully get confirmation list" do
      event = create_test_event()
      user = create_test_user()

      assert {:ok, %Content.Confirmation{} = confirmation} =
               Content.Event.confirm_event(%{"event_id" => event.id, "user_id" => user.id})

      assert Content.list_confirmations() == [confirmation]
    end

    test "successfully get ids list of users confirmed event" do
      event = create_test_event()
      user = create_test_user()
      Content.Event.confirm_event(%{"event_id" => event.id, "user_id" => user.id})
      Content.user_email_list_by_event_id(event.id) == [user.id]
    end

    test "successfully get confirmation with valid params" do
      event = create_test_event()
      user = create_test_user()

      assert {:ok, %Content.Confirmation{} = confirmation} =
               Content.Event.confirm_event(%{"event_id" => event.id, "user_id" => user.id})

      Content.get_confirmation!(confirmation.id) == confirmation
    end
  end
end
