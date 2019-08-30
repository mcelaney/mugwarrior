defmodule MugwarriorWeb.OrganizationView do
  use MugwarriorWeb, :view
  alias Mugwarrior.Membership.Organization

  @spec organizations(Plug.Conn.t()) :: list(Organization.t())
  def organizations(%{assigns: %{current_user: %{profile: %{organizations: orgs}}}}) do
    orgs || []
  end

  def organizations(_), do: []
end
