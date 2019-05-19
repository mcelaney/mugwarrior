defmodule MugwarriorWeb.Auth.UserController do
  use MugwarriorWeb, :controller

  alias Mugwarrior.Auth
  alias Mugwarrior.Auth.User
  alias MugwarriorWeb.Guardian.Tokenizer.Plug, as: GuardianPlug

  @spec new(Plug.Conn.t(), any) :: Plug.Conn.t()
  def new(conn, _params) do
    changeset = Auth.change_user(%User{})

    conn
    |> GuardianPlug.sign_out()
    |> render("new.html", changeset: changeset)
  end

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t() | no_return()
  def create(conn, %{"user" => user_params}) do
    case Auth.authenticate_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User Logged In Successfully.")
        |> GuardianPlug.sign_in(user)
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Username/Password combination did not exist.")
        |> render("new.html", changeset: changeset)
    end
  end

  @spec delete(Plug.Conn.t(), any) :: Plug.Conn.t()
  def delete(conn, _) do
    conn
    |> GuardianPlug.sign_out()
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
