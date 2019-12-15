defmodule MyApp.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add(:description, :string)
      add(:timestamp, :naive_datetime)
      add(:author_id, references(:users, on_delete: :nothing))

      timestamps()
    end

    create(index(:events, [:author_id]))
  end
end
