defmodule MyAppWeb.UsersResolver do
  def all_users(_root, _args, _info) do
    users = MyApp.Accounts.list_users()
    {:ok, users}
  end

  def find_user(%{id: id}, _info) do
    case MyApp.Accounts.get_user(id) do
      nil -> {:error, "User id #{id} not found!"}
      user -> {:ok, user}
    end
  end
end
