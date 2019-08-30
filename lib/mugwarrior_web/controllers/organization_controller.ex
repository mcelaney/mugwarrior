defmodule MugwarriorWeb.OrganizationController do
  use MugwarriorWeb, :controller
  alias Plug.Conn

  plug MugwarriorWeb.CurrentOrganizationPlug
  plug MugwarriorWeb.EnsureUserAuthorizedPlug

  @spec show(Conn.t(), map) :: Conn.t()
  def show(conn, _) do
    render(conn, "show.html", org: conn.assigns.current_organization)
  end
end
