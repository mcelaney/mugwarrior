defmodule MugwarriorWeb.OrganizationController do
  use MugwarriorWeb, :controller

  alias Mugwarrior.Membership
  alias Mugwarrior.Membership.Profile

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"id" => slug}) do
    org = conn |> profile() |> Membership.get_organization!(slug)
    render(conn, "show.html", org: org)
  end

  @spec profile(Plug.Conn.t()) :: Profile.t()
  defp profile(%{assigns: %{current_user: %{profile: profile}}}), do: profile
end
