defmodule MugwarriorWeb.Signup.UserController do
  use MugwarriorWeb, :controller

  alias Mugwarrior.Signup
  alias Mugwarrior.Signup.User
  alias MugwarriorWeb.Guardian.Tokenizer.Plug, as: GuardianPlug

  @spec new(Plug.Conn.t(), any) :: Plug.Conn.t()
  def new(conn, _params) do
    changeset = Signup.change_user(%User{})

    conn
    |> GuardianPlug.sign_out()
    |> render("new.html", changeset: changeset)
  end

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t() | no_return()
  def create(conn, %{"user" => user_params}) do
    case Signup.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> GuardianPlug.sign_in(user)
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
