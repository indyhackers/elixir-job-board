defmodule ElixirJobBoard.UserTest do
  use ElixirJobBoard.ModelCase

  alias ElixirJobBoard.User

  @valid_attrs %{password: "some content", email: "some_content@some_content.com"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "is_admin? with admin user" do
    assert User.is_admin?(%User{ admin: true })
  end

  test "is_admin? with non admin user" do
    refute User.is_admin?(%User{ admin: false })
  end
end
