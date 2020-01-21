defmodule MyAppWeb.UsersResolver do
  def all_users(_root, _args, _info) do
    users = MyApp.Accounts.list_users()
    {:ok, users}
  end

  def list_users_confrimed_event(_root, _args, _info) do
    users = MyApp.Content.list_users_confirmed_event(_root.id)
    {:ok, users}
  end

  def find_user(params, _info) do
    case MyApp.Accounts.get_user(params) do
      nil -> {:error, "User with params #{params} not found!"}
      user -> {:ok, user}
    end
  end

  def find_user_by_email(%{email: email}, _info) do
    case MyApp.Accounts.get_user_by_email(email) do
      nil -> {:error, "User email #{email} not found!"}
      user -> {:ok, user}
    end
  end

  def find_user_by_confirmation(%{user_id: id}, _info) do
    case MyApp.Accounts.get_user(id) do
      nil -> {:error, "User id #{id} not found!"}
      user -> {:ok, user}
    end
  end

  def find_author(_root, _args, _info) do
    case MyApp.Accounts.get_user(_root.user_id) do
      nil -> {:error, "User id #{_root.user_id} not found!"}
      user -> {:ok, user}
    end
  end
end
