defmodule MyAppWeb.UsersResolver do
  alias MyApp.Accounts

  def all_users(_root, _args, _info) do
    users = Accounts.list_users()
    {:ok, users}
  end

  def list_users_confrimed_event(_root, _args, _info) do
    users = MyApp.Content.list_users_confirmed_event(_root.id)
    {:ok, users}
  end

  def find_user(params, _info) do
    case Accounts.get_user(params) do
      nil -> {:error, "User with params #{params} not found!"}
      user -> {:ok, user}
    end
  end

  def find_user_by_email(%{email: email}, _info) do
    case Accounts.get_user_by_email(email) do
      nil -> {:error, "User email #{email} not found!"}
      user -> {:ok, user}
    end
  end

  def find_user_by_confirmation(%{user_id: id}, _info) do
    case Accounts.get_user(id) do
      nil -> {:error, "User id #{id} not found!"}
      user -> {:ok, user}
    end
  end

  def find_author(root, _args, _info) do
    case Accounts.get_user(root.user_id) do
      nil -> {:error, "User id #{root.user_id} not found!"}
      user -> {:ok, user}
    end
  end

  def create_user(_root, args, _info) do
    case Accounts.get_or_create_by_email(args.email) do
      nil -> "User with #{args} not created!"
      user -> user
    end
  end
end
