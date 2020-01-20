defmodule MyApp.Content do
  import Ecto.Query, warn: false
  alias MyApp.Repo
  alias MyApp.Content.Event
  alias MyApp.Content.Confirmation
  alias MyApp.Accounts.User

  def list_events_api do
    query =
      from(event in Event,
        join: user in User,
        on: event.user_id == user.id,
        select: %{
          id: event.id,
          description: event.description,
          timestamp: event.timestamp,
          author_id: event.user_id,
          author_email: user.email
        }
      )

    Repo.all(query)
  end

  def get_event_api(id) do
    query =
      from(event in Event,
        join: user in User,
        on: event.user_id == user.id,
        where: event.id == ^id,
        select: %{
          id: event.id,
          description: event.description,
          timestamp: event.timestamp,
          author_id: event.user_id,
          author_email: user.email
        }
      )

    Repo.one(query)
  end

  def list_events do
    Repo.all(Event)
  end

  def get_event!(id), do: Repo.get!(Event, id)

  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  def change_event(%Event{} = event) do
    Event.changeset(event, %{})
  end

  def list_confirmations do
    Repo.all(Confirmation)
  end

  def event_confirmations_list(id) do
    from(c in Confirmation,
      where: c.event_id == ^id,
      select: c
    )
    |> Repo.all()
  end

  def list_user_confirmed_event_ids(user) do
    if user do
      from(c in Confirmation,
        where: c.user_id == ^user.id,
        select: c.event_id
      )
      |> Repo.all()
    else
      []
    end
  end

  def user_list_by_event_id(event_id) do
    from(u in User,
      join: c in assoc(u, :confirmations),
      where: c.event_id == ^event_id,
      select: u
    )
    |> Repo.all()
  end

  def get_confirmation!(id), do: Repo.get!(Confirmation, id)

  def create_confirmation(attrs \\ %{}) do
    %Confirmation{}
    |> Confirmation.changeset(attrs)
    |> Repo.insert()
  end

  def change_confirmation(%Confirmation{} = confirmation) do
    Confirmation.changeset(confirmation, %{})
  end
end
