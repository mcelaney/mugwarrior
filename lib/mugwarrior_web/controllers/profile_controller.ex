defmodule MugwarriorWeb.ProfileController do
  use MugwarriorWeb, :controller

  alias Mugwarrior.Membership

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    profiles = Membership.list_profiles()
    render(conn, "index.html", profiles: profiles)
  end

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    profile = Membership.get_profile!(id)
    render(conn, "show.html", profile: profile)
  end

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
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  defp current_user(conn), do: conn.assigns.current_user
end
