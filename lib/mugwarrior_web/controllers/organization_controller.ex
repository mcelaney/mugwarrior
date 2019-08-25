defmodule MugwarriorWeb.OrganizationController do
  use MugwarriorWeb, :controller

  plug MugwarriorWeb.CurrentOrganizationPlug
  plug MugwarriorWeb.EnsureUserAuthorizedPlug

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, _) do
    render(conn, "show.html", org: conn.assigns.current_organization)
  end
end
