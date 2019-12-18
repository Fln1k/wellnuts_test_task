defmodule MyApp.UserEventConfirmation do
  import Ecto.Query, warn: false
  alias MyApp.Repo

  alias MyApp.UserEventConfirmation.Confirmation
  alias MyApp.Accounts.User

  def list_confirmations do
    Repo.all(Confirmation)
  end

  def list_user_confirmed_event_ids(user) do
    if user do
      from(u in Confirmation,
        where: u.user_id == ^user.id,
        select: u.event_id
      )
      |> Repo.all()
    else
      []
    end
  end

  def user_email_list_by_event_id(event_id) do
    from(u in User,
      join: c in assoc(u, :confirmations),
      where: c.event_id == ^event_id,
      select: u.email
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
