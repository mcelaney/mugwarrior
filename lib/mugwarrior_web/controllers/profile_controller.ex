defmodule MugwarriorWeb.ProfileController do
  use MugwarriorWeb, :controller

  alias Mugwarrior.Membership
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

  @spec current_user(Plug.Conn.t()) :: User.t()
  defp current_user(conn), do: conn.assigns.current_user
end
