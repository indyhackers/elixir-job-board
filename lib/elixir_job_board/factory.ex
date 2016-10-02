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

  def user_factory do
    %ElixirJobBoard.User{
      email: "some_content@some_content.com",
      # User password is password the value for the key crypted_paswword
      # is the hashed value for password
      crypted_password: "$2b$12$PryIurhZCfAgTXW0Rqz0oOAxJ00WV6OU30cvWsoyGefFNhmDnq6K2",
      admin: false
    }
  end
end
