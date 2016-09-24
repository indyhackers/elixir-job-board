defmodule ElixirJobBoard.JobTest do
  use ElixirJobBoard.ModelCase

  alias ElixirJobBoard.Job

  @valid_attrs %{contact_email: "some content", description: "some content", location: "some content", poster_email: "some content", published_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Job.changeset(%Job{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Job.changeset(%Job{}, @invalid_attrs)
    refute changeset.valid?
  end
end
