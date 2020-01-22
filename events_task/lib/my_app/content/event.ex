defmodule MyApp.Content.Event do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyApp.Content.Confirmation

  schema "events" do
    field(:description, :string)
    field(:timestamp, :naive_datetime)
    belongs_to(:user, User)
    has_many(:confirmations, MyApp.Content.Confirmation)
    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:description, :timestamp, :user_id])
    |> validate_required([:description, :timestamp])
    |> foreign_key_constraint(:user_id, message: "User don't exist")
  end

  def confirm_event(attrs \\ %{}) do
    %Confirmation{}
    |> Confirmation.changeset(attrs)
    |> MyApp.Repo.insert()
  end
end
