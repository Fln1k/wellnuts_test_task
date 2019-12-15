defmodule MyApp.Content.Event do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyApp.Contents.Event
  alias MyApp.UserEventConfirmation.Confirmation

  schema "events" do
    field(:description, :string)
    field(:timestamp, :naive_datetime)
    field(:author_id, :id)
    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:description, :timestamp, :author_id])
    |> validate_required([:description, :timestamp])
  end

  def confirm_event(attrs \\ %{}) do
    %Confirmation{}
    |> Confirmation.changeset(attrs)
    |> Repo.insert()
  end
end
