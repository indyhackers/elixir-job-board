defmodule ElixirJobBoard.Router do
  use ElixirJobBoard.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ElixirJobBoard do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete

    resources "/posts", PostsController
  end

  scope "/admin", ElixirJobBoard do
    pipe_through [:browser, ElixirJobBoard.Plugs.AuthenticateAdmin]

    resources "/jobs", Admin.JobController
  end

  # Other scopes may use custom stacks.
  # scope "/api", ElixirJobBoard do
  #   pipe_through :api
  # end
end
