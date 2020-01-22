defmodule MyApp.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add(:description, :string)
      add(:timestamp, :naive_datetime)
      add(:user_id, references(:users, on_delete: :delete_all))

      timestamps()
    end

    create(index(:events, [:user_id]))
  end
end
