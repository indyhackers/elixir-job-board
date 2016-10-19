defmodule ElixirJobBoard.Repo.Migrations.AddUserIdToJobs do
  use Ecto.Migration

  def change do
    alter table(:job) do
      add :user_id, references(:users)
    end
  end
end
