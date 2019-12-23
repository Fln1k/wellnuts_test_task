defmodule MyApp.UserEventConfirmation.Confirmation do
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
    |> validate_required([:user_id, :event_id])
  end
end
