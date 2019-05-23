defmodule MugwarriorWeb.ProfileController do
  use MugwarriorWeb, :controller

  alias Mugwarrior.Membership
  alias Mugwarrior.Membership.Organization
  alias Mugwarrior.Membership.Profile
  alias Mugwarrior.Membership.User

  @spec edit(Plug.Conn.t(), any) :: Plug.Conn.t()
  def edit(conn, _params) do
    render(conn, "edit.html",
      profile: conn |> current_user() |> Map.get(:profile),
      changeset: conn |> current_user() |> Membership.change_profile()
    )
  end

  @spec update(Plug.Conn.t(), map) :: Plug.Conn.t() | no_return()
  def update(conn, %{"profile" => params}) do
    case conn |> current_user() |> Membership.update_profile(params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, gettext("User updated successfully."))
        |> redirect(to: Routes.page_path(conn, :dashboard))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def update(conn, %{"organization_id" => slug, "role" => "promote", "profile_id" => profile_id}) do
    Membership.promote_profile_to_org_admin(%{id: profile_id}, get_org(conn, slug))

    _update(conn, gettext("User promoted successfully."), slug)
  end

  def update(conn, %{"organization_id" => slug, "role" => "demote", "profile_id" => profile_id}) do
    Membership.demote_profile_to_org_member(%{id: profile_id}, get_org(conn, slug))

    _update(conn, gettext("User demoted successfully."), slug)
  end

  defp _update(conn, message, slug) do
    conn
    |> put_flash(:info, message)
    |> redirect(to: Routes.organization_path(conn, :show, slug))
  end

  @spec current_user(Plug.Conn.t()) :: User.t()
  defp current_user(conn), do: conn.assigns.current_user

  @spec profile(Plug.Conn.t()) :: Profile.t()
  defp profile(%{assigns: %{current_user: %{profile: profile}}}), do: profile

  @spec get_org(Plug.Conn.t(), String.t()) :: Organization.t()
  defp get_org(conn, slug), do: conn |> profile() |> Membership.get_organization!(slug)
end
