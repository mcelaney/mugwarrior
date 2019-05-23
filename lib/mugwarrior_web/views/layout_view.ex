defmodule MugwarriorWeb.LayoutView do
  use MugwarriorWeb, :view

  @spec logo_link(Plug.Conn.t()) :: String.t()
  def logo_link(%{assigns: %{current_user: nil}} = conn) do
    Routes.page_path(conn, :index)
  end

  def logo_link(conn) do
    Routes.page_path(conn, :dashboard)
  end

  @spec organizations(Plug.Conn.t()) :: list(Mugwarrior.Membership.Organization.t())
  def organizations(%{assigns: %{current_user: %{profile: %{organizations: orgs}}}}) do
    orgs || []
  end

  def organizations(_), do: []
end
