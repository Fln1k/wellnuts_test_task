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
  end
end
