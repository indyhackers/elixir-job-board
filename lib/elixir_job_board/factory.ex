defmodule ElixirJobBoard.Factory do
  use ExMachina.Ecto, repo: ElixirJobBoard.Repo

  def job_factory do
    %ElixirJobBoard.Job{title: "Something Important",
      description: "a new job",
       poster_email: "poster.email@example.com",
       contact_email: "contact.email@example.com",
       location: "Somewhere",
       published_at: Ecto.DateTime.utc}
  end
end
