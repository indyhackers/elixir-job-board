defmodule ElixirJobBoard.JobsController do
  use ElixirJobBoard.Web, :controller

  plug ElixirJobBoard.Plugs.LoginWithToken when action in [:edit, :update, :destroy]
  plug ElixirJobBoard.Plugs.AuthenticateJobPoster when action in [:edit, :update, :destroy]
  plug ElixirJobBoard.Plugs.AuthorizeJobPoster when action in [:edit, :update, :destroy]

  alias ElixirJobBoard.Job

  def index(conn, _params) do
    jobs = Job
            |> where([job], job.published_at < ^Ecto.DateTime.utc)
            |> order_by(:published_at)
            |> Repo.all
    render conn, "index.html", jobs: jobs
  end

  def show(conn, %{"id" => id}) do
    job = Repo.get(Job, id)
    render conn, "show.html", job: job
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
        |> redirect(to: jobs_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    job = Repo.get(Job, id)
    changeset = Job.changeset(job)
    render(conn, "edit.html", job: job, changeset: changeset)
  end

  def update(conn, %{"id" => id, "job" => job_params}) do
    job = Repo.get(Job, id)
    changeset = Job.changeset(job, job_params)

    case Repo.update(changeset) do
      {:ok, _job} ->
        conn
        |> put_flash(:info, "Job successfully updated.")
        |> redirect(to: jobs_path(conn, :show, id))
      {:error, changeset} ->
        render(conn, "edit.html", id: id, changeset: changeset, job: job)
    end
  end
end
