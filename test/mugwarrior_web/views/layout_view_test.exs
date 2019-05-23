defmodule MugwarriorWeb.LayoutViewTest do
  use MugwarriorWeb.ConnCase, async: true
  alias MugwarriorWeb.LayoutView

  test "logo_link/1 returns an index url with no current user", %{conn: conn} do
    conn
    |> Plug.Conn.assign(:current_user, nil)
    |> LayoutView.logo_link()
    |> Kernel.==("/")
    |> assert()
  end

  test "logo_link/1 returns an index url with a non-nil current user", %{conn: conn} do
    conn
    |> Plug.Conn.assign(:current_user, "any non nil value")
    |> LayoutView.logo_link()
    |> Kernel.==("/dashboard")
    |> assert()
  end
end
