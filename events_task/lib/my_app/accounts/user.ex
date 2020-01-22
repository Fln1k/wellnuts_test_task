defmodule MyApp.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyApp.Accounts.User

  schema "users" do
    field(:email, :string)
    has_many(:events, MyApp.Content.Event)
    has_many(:confirmations, MyApp.Content.Confirmation)
    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email])
    |> unique_constraint(:email)
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+-+']+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/)
  end
end
