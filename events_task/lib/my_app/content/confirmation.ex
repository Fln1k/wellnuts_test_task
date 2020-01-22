defmodule MyApp.Content.Confirmation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "confirmations" do
    belongs_to(:user, User)
    belongs_to(:event, Event)
    timestamps()
  end

  def changeset(confirmation, attrs) do
    confirmation
    |> cast(attrs, [:user_id, :event_id])
    |> unique_constraint(:user_id, name: :user_event)
    |> validate_required([:user_id, :event_id])
    |> foreign_key_constraint(:user_id, message: "User don't exist")
    |> foreign_key_constraint(:event_id, message: "Event don't exist")
  end
end
