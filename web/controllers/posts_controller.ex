defmodule ElixirJobBoard.PostsController do
  use ElixirJobBoard.Web, :controller

  def index(conn, _params) do
    jobs = Repo.all(ElixirJobBoard.Job)
    render conn, "index.html", jobs: jobs
  end

  def show(conn, %{"id" => id}) do
    post = Repo.get(ElixirJobBoard.Job, id)
    render conn, "show.html", post: post
  end
end
