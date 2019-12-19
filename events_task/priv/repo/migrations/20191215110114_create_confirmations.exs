defmodule MyApp.Repo.Migrations.CreateConfirmations do
  use Ecto.Migration

  def change do
    create table(:confirmations) do
      add(:user_id, references(:users, on_delete: :delete_all))
      add(:event_id, references(:events, on_delete: :delete_all))

      timestamps()
    end

    create(index(:confirmations, [:user_id]))
    create(index(:confirmations, [:event_id]))
  end
end
