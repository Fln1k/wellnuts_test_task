defmodule MyApp.AccountsTest do
  use MyApp.DataCase

  alias MyApp.Accounts

  describe "users" do
    alias MyApp.Accounts.User

    @valid_attrs %{email: "sergei@gmail.com"}
    @update_attrs %{email: "sergei11@gmail.com"}
    @invalid_attrs %{email: nil}

    def create_test_user(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "get user_list" do
      user = create_test_user()
      assert Accounts.get_user(user.id) == user
    end

    test "get user with valid params" do
      user = create_test_user()
      assert Accounts.list_users() == [user]
    end

    test "create_user with valid data" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "sergei@gmail.com"
    end

    test "create_user with invalid data" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update user with valid data" do
      user = create_test_user()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "sergei11@gmail.com"
    end

    test "update user with invalid data" do
      user = create_test_user()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
    end

    test "change user" do
      user = create_test_user()
      assert %Ecto.Changeset{} = Accounts.change_user(%{:email => user.email})
    end
  end
end
