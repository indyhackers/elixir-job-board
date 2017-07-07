defmodule :"Elixir.ElixirJobBoard.Repo.Migrations.Add-company-name-column-to-jobs" do
  use Ecto.Migration

  def change do
    alter table(:jobs) do
      add :company_name, :string
    end
  end
end
