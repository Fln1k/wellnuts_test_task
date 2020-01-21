defmodule MyApp.Content do
  import Ecto.Query, warn: false
  alias MyApp.Repo
  alias MyApp.Content.Event
  alias MyApp.Content.Confirmation
  alias MyApp.Accounts.User

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

  def list_confirmations_by_user(id) do
    from(c in Confirmation,
      where: c.user_id == ^id,
      select: c
    )
    |> Repo.all()
  end

  def list_confirmations_by_event(id) do
    from(c in Confirmation,
      where: c.event_id == ^id,
      select: c
    )
    |> Repo.all()
  end

  def list_events_by_author_id(id) do
    from(e in Event,
      where: e.user_id == ^id,
      select: e
    )
    |> Repo.all()
  end

  def list_events_confirmed(user) do
    if user do
      from(e in Event,
        join: c in Confirmation,
        on: c.event_id == e.id,
        where: c.user_id == ^user.id,
        select: e
      )
      |> Repo.all()
    else
      []
    end
  end

  def list_users_confirmed_event(event_id) do
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
