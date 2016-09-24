defmodule ElixirJobBoard.Repo.Migrations.CreateJob do
  use Ecto.Migration

  def change do
    create table(:job) do
      add :title, :string
      add :description, :text
      add :poster_email, :string
      add :contact_email, :string
      add :location, :string
      add :published_at, :datetime

      timestamps()
    end

  end
end
