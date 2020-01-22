defmodule MyAppWeb.UsersResolver do
  alias MyApp.Accounts

  def all_users(_root, _args, _info) do
    users = Accounts.list_users()
    {:ok, users}
  end

  def list_users_confirmed_event(_root, _args, _info) do
    users = MyApp.Content.list_users_confirmed_event(_root.id)
    {:ok, users}
  end

  def find_user(params, _info) do
    case Accounts.get_user(params) do
      {:error, changeset} -> {:error, "User with params #{params} not found!"}
      user -> {:ok, user}
    end
  end

  def find_author(root, _args, _info) do
    case Accounts.get_user(root.user_id) do
      {:error, changeset} -> {:error, "User id #{root.user_id} not found!"}
      user -> {:ok, user}
    end
  end

  def create_user(_root, args, _info) do
    case Accounts.get_or_create_by_email(args.email) do
      {:error, changeset} -> {:error, "User not created"}
      user -> user
    end
  end
end
