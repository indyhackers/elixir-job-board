defmodule ElixirJobBoard.Job do
  use ElixirJobBoard.Web, :model

  schema "jobs" do
    field :title, :string
    field :description, :string
    field :poster_email, :string
    field :contact_email, :string
    field :location, :string
    field :published_at, Ecto.DateTime

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :description, :poster_email, :contact_email, :location, :published_at])
    |> validate_required([:title, :description, :poster_email, :contact_email, :location, :published_at])
  end
end
