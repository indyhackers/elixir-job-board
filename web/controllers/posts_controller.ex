defmodule ElixirJobBoard.PostsController do
  use ElixirJobBoard.Web, :controller

  alias ElixirJobBoard.Job

  def index(conn, _params) do
    jobs = Repo.all(ElixirJobBoard.Job)
    render conn, "index.html", jobs: jobs
  end

  def show(conn, %{"id" => id}) do
    post = Repo.get(ElixirJobBoard.Job, id)
    render conn, "show.html", post: post
  end

  def new(conn, _params) do
    changeset = Job.changeset(%Job{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"job" => job_params}) do
    changeset = Job.changeset(%Job{}, job_params)

    case Repo.insert(changeset) do
      {:ok, _job} ->
        conn
        |> put_flash(:info, "Job created successfully.")
        |> redirect(to: posts_path(conn, :index))
      {:error, changeset} ->
        render("new.html", changeset: changeset)
    end
  end
end
