defmodule ElixirJobBoard.RegistrationTest do
  use ElixirJobBoard.ModelCase

  alias ElixirJobBoard.Registration
  alias ElixirJobBoard.User

  @valid_attrs %{ password: "some content", email: "some_content@some_content.com" }
  @invalid_attrs %{ password: "some content" }

  test "creates a user when given valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    result = Registration.create(changeset, ElixirJobBoard.Repo) 
    assert elem(result, 0) == :ok
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    result = Registration.create(changeset, ElixirJobBoard.Repo) 
    refute elem(result, 0) == :ok
  end
end
