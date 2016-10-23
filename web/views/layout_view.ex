defmodule ElixirJobBoard.LayoutView do
  use ElixirJobBoard.Web, :view
  import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 1, view_module: 1]

  def show_flash(conn) do
    Phoenix.Controller.get_flash(conn) |> flash_msg
  end

  def flash_msg(%{"info" => msg}) do
    ~E"<div class='alert alert-info' role='alert'><p><%= msg %></div>"
  end

  def flash_msg(%{"error" => msg}) do
    ~E"<div class='alert alert-danger' role='alert'><%= msg %></div>"
  end

  def flash_msg(_) do
    nil
  end
end
