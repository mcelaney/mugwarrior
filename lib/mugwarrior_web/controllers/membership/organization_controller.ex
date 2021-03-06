defmodule MugwarriorWeb.Membership.OrganizationController do
  use MugwarriorWeb, :controller

  alias Mugwarrior.Membership
  alias Mugwarrior.Membership.Organization
  alias Plug.Conn

  @spec new(Conn.t(), any) :: Conn.t()
  def new(conn, _params) do
    changeset = Membership.change_organization(%Organization{})
    render(conn, "new.html", changeset: changeset)
  end

  @spec create(Conn.t(), map) :: Conn.t()
  def create(conn, %{"organization" => organization_params}) do
    case Membership.create_organization(conn.assigns.current_user.profile, organization_params) do
      {:ok, organization} ->
        conn
        |> put_flash(:info, gettext("Swap Group created successfully."))
        |> redirect(to: Routes.organization_path(conn, :show, organization.slug))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
