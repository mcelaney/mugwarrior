defmodule MugwarriorWeb.InvitationController do
  use MugwarriorWeb, :controller

  alias Mugwarrior.Membership
  alias Mugwarrior.Membership.Invitation

  @spec new(Plug.Conn.t(), map) :: Plug.Conn.t() | no_return()
  def new(conn, %{"organization_id" => slug}) do
    changeset = Membership.change_invitation(%Invitation{})

    conn
    |> Plug.Conn.assign(:organization_slug, slug)
    |> render("new.html", changeset: changeset)
  end

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t() | no_return()
  def create(conn, %{"organization_id" => slug, "invitation" => params}) do
    slug
    |> Membership.create_invitation(params)
    |> case do
      {:ok, _invitation} ->
        conn
        |> put_flash(:info, "Invitation created successfully.")
        |> redirect(to: Routes.organization_path(conn, :show, slug))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> Plug.Conn.assign(:organization_slug, slug)
        |> render("new.html", changeset: changeset)
    end
  end

  @spec update(Plug.Conn.t(), map) :: Plug.Conn.t() | no_return()
  def update(conn, %{"id" => invitation_id}) do
    invitation_id
    |> Membership.accept_invite(conn.assigns.current_user)
    |> case do
      {:ok, organization} ->
        conn
        |> put_flash(:info, "Invitation accepted successfully.")
        |> redirect(to: Routes.organization_path(conn, :show, organization.slug))

      {:error, _} ->
        conn
        |> put_flash(:info, "Invitation not found.")
        |> redirect(to: Routes.page_path(conn, :dashboard))
    end
  end

  @spec delete(Plug.Conn.t(), map) :: Plug.Conn.t() | no_return()
  def delete(conn, %{"organization_id" => slug, "id" => id}) do
    invitation = Membership.get_invitation!(slug, id)
    {:ok, _invitation} = Membership.delete_invitation(invitation)

    conn
    |> put_flash(:info, "Invitation deleted successfully.")
    |> redirect(to: Routes.organization_path(conn, :show, slug))
  end
end
