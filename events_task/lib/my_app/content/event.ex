defmodule MyApp.Content.Event do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyApp.UserEventConfirmation.Confirmation

  schema "events" do
    field(:description, :string)
    field(:timestamp, :naive_datetime)
    belongs_to(:user, User)
    has_many(:confirmations, MyApp.UserEventConfirmation.Confirmation)
    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:description, :timestamp, :user_id])
    |> validate_required([:description, :timestamp])
  end

  def confirm_event(attrs \\ %{}) do
    %Confirmation{}
    |> Confirmation.changeset(attrs)
    |> MyApp.Repo.insert()
  end
end
