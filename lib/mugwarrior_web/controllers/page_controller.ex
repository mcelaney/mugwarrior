defmodule MugwarriorWeb.PageController do
  use MugwarriorWeb, :controller

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    render(conn, "index.html")
  end

  @spec dashboard(Plug.Conn.t(), any) :: Plug.Conn.t()
  def dashboard(conn, _params) do
    render(conn, "dashboard.html")
  end
end
