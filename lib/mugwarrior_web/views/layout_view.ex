defmodule MugwarriorWeb.LayoutView do
  use MugwarriorWeb, :view
  alias Mugwarrior.Membership.Invitation
  alias Mugwarrior.Membership.Organization

  @spec logo_link(Plug.Conn.t()) :: String.t()
  def logo_link(%{assigns: %{current_user: nil}} = conn) do
    Routes.page_path(conn, :index)
  end

  def logo_link(conn) do
    Routes.page_path(conn, :dashboard)
  end

  @spec organizations(Plug.Conn.t()) :: list(Organization.t())
  def organizations(%{assigns: %{current_user: %{profile: %{organizations: orgs}}}}) do
    orgs || []
  end

  def organizations(_), do: []

  @spec invitations(Plug.Conn.t()) :: list(Invitation.t())
  def invitations(%{assigns: %{current_user_invitations: invites}}), do: invites

  def invitations(_), do: []
end
