defmodule MyApp.UserEventConfirmation do
  @moduledoc """
  The UserEventConfirmation context.
  """

  import Ecto.Query, warn: false
  alias MyApp.Repo

  alias MyApp.UserEventConfirmation.Confirmation
  alias MyApp.Accounts.User

  @doc """
  Returns the list of confirmations.

  ## Examples

      iex> list_confirmations()
      [%Confirmation{}, ...]

  """
  def list_confirmations do
    Repo.all(Confirmation)
  end

  def user_list_events(user) do
    if user do
      Repo.all(
        from(u in Confirmation,
          where: u.user_id == type(^user.id, :integer),
          select: u.event_id
        )
      )
    else
      []
    end
  end

  def user_email_list_by_event_id(event_id) do
    user_ids =
      Repo.all(
        from(u in Confirmation,
          where: u.event_id == type(^event_id, :integer),
          select: u.user_id
        )
      )

    Repo.all(
      from(u in User,
        where: u.id in ^user_ids,
        select: u.email
      )
    )
  end

  @doc """
  Gets a single confirmation.

  Raises `Ecto.NoResultsError` if the Confirmation does not exist.

  ## Examples

      iex> get_confirmation!(123)
      %Confirmation{}

      iex> get_confirmation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_confirmation!(id), do: Repo.get!(Confirmation, id)

  @doc """
  Creates a confirmation.

  ## Examples

      iex> create_confirmation(%{field: value})
      {:ok, %Confirmation{}}

      iex> create_confirmation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_confirmation(attrs \\ %{}) do
    %Confirmation{}
    |> Confirmation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a confirmation.

  ## Examples

      iex> update_confirmation(confirmation, %{field: new_value})
      {:ok, %Confirmation{}}

      iex> update_confirmation(confirmation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @doc """
  Deletes a Confirmation.

  ## Examples

      iex> delete_confirmation(confirmation)
      {:ok, %Confirmation{}}

      iex> delete_confirmation(confirmation)
      {:error, %Ecto.Changeset{}}

  """

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking confirmation changes.

  ## Examples

      iex> change_confirmation(confirmation)
      %Ecto.Changeset{source: %Confirmation{}}

  """
  def change_confirmation(%Confirmation{} = confirmation) do
    Confirmation.changeset(confirmation, %{})
  end
end
