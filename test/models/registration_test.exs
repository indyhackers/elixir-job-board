defmodule ElixirJobBoard.RegistrationTest do
  use ElixirJobBoard.ModelCase

  alias ElixirJobBoard.Registration
  alias ElixirJobBoard.User

  @valid_attrs %{ password: "some content", email: "some_content@some_content.com" }
  @invalid_attrs %{ password: "some content" }

  test "creates a user when given valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert ElixirJobBoard.Repo.get_by(User, email: "some_content@some_content.com") == nil
    Registration.create(changeset, ElixirJobBoard.Repo)
    refute ElixirJobBoard.Repo.get_by(User, email: "some_content@some_content.com") == nil
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    assert ElixirJobBoard.Repo.get_by(User, email: "some_content@some_content.com") == nil
    Registration.create(changeset, ElixirJobBoard.Repo)
    assert ElixirJobBoard.Repo.get_by(User, email: "some_content@some_content.com") == nil
  end
end
