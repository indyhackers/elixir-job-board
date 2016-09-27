# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ElixirJobBoard.Repo.insert!(%ElixirJobBoard.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# Empty the users table
ElixirJobBoard.Repo.delete_all(ElixirJobBoard.User)

default_password = "password"

pg_changeset = ElixirJobBoard.User.changeset(
  %ElixirJobBoard.User{},
  %{ "email" => "pg13@pacers.com", "password" => "password" }
)
myles_changeset = ElixirJobBoard.User.changeset(
  %ElixirJobBoard.User{},
  %{ "email" => "myles@pacers.com", "password" => "password" }
)
zeisloft_changeset = ElixirJobBoard.User.changeset(
  %ElixirJobBoard.User{},
  %{ "email" => "nick.zeisloft.iu@pacers.com", "password" => "password" }
)

ElixirJobBoard.Registration.create(pg_changeset, ElixirJobBoard.Repo)
ElixirJobBoard.Registration.create(myles_changeset, ElixirJobBoard.Repo)
ElixirJobBoard.Registration.create(zeisloft_changeset, ElixirJobBoard.Repo)
