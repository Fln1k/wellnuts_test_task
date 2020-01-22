defmodule MyApp.AccountsTest do
  use MyApp.DataCase

  alias MyApp.Accounts

  describe "users" do
    alias MyApp.Accounts.User

    @valid_attrs %{email: "sergei@example.com"}
    @update_attrs %{email: "sergei11@example.com"}
    @invalid_attrs %{email: nil}

    def create_test_user(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "successfully get user" do
      user = create_test_user()
      assert Accounts.get_user(user.id) == user
    end

    test "successfully get user list with valid params" do
      user = create_test_user()
      assert Accounts.list_users() == [user]
    end

    test "successfully create user with valid params" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "sergei@example.com"
    end

    test "fails create_user with invalid params" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "successfully update user with valid params" do
      user = create_test_user()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "sergei11@example.com"
    end

    test "fails update user with invalid params" do
      user = create_test_user()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
    end

    test "successfully change user" do
      user = create_test_user()
      assert %Ecto.Changeset{} = Accounts.change_user(%{:email => user.email})
    end
  end
end
