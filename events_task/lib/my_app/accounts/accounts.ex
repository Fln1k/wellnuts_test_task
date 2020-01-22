defmodule MyApp.Accounts do
  import Ecto.Query, warn: false
  alias MyApp.Repo

  alias MyApp.Accounts.User

  def list_users do
    Repo.all(User)
  end

  def get_user(param) when not is_map(param) do
    Repo.get(User, param)
  end

  def get_user(id) when is_integer(id), do: Repo.get(User, id)
  def get_user(params) when is_map(params), do: Repo.get_by(User, params)

  def get_or_create_by_email(email) do
    case Repo.get_by(User, email: email) do
      nil ->
        create_user(%{email: email})

      user ->
        {:ok, user}
    end
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def change_user(attrs \\ %{}) do
    User.changeset(%User{}, attrs)
  end
end
