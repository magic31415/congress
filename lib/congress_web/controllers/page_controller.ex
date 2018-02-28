defmodule CongressWeb.PageController do
  use CongressWeb, :controller

  def index(conn, _params) do
  	render conn, "index.html"
  end
end
