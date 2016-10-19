defmodule ElixirJobBoard.Repo.Migrations.RenameJobTableToJobs do
  use Ecto.Migration

  def change do
    rename table(:job), to: table(:jobs)
  end
end
