defmodule MyApp.Repo.Migrations.CreateConfirmations do
  use Ecto.Migration

  def change do
    create table(:confirmations) do
      add(:user_id, references(:users, on_delete: :nothing))
      add(:event_id, references(:events, on_delete: :nothing))

      timestamps()
    end

    create(index(:confirmations, [:user_id]))
    create(index(:confirmations, [:event_id]))
  end
end
