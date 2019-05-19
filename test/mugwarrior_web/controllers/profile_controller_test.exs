defmodule MugwarriorWeb.ProfileControllerTest do
  use MugwarriorWeb.ConnCase

  alias Mugwarrior.Membership
  alias Mugwarrior.Membership.Profile
  alias Mugwarrior.Membership.User
  alias Mugwarrior.Repo

  @update_attrs %{
    description: "I'm an Elixir Developer who loves BBQ",
    first: "Pattern",
    last: "Toaster",
    slug: "mac2"
  }

  @invalid_attrs %{slug: nil}

  describe "given a user with a profile" do
    setup do
      user = %User{profile: %Profile{slug: "mac"}} |> Repo.insert!()

      [user: Membership.get_user(user.id)]
    end

    test "edit profile renders form for editing chosen profile", %{conn: conn} do
      conn = conn |> authed_conn() |> get(Routes.profile_path(conn, :edit))
      assert html_response(conn, 200) =~ "Edit Profile"
    end

    test "update profile redirects when data is valid", %{conn: conn, user: user} do
      updated_conn =
        conn
        |> authed_conn(user)
        |> put(Routes.profile_path(conn, :update), profile: @update_attrs)

      assert redirected_to(updated_conn) == Routes.page_path(updated_conn, :index)

      profile_conn =
        updated_conn
        |> recycle()
        |> authed_conn(user)
        |> get(Routes.profile_path(updated_conn, :show, "mac2"))

      assert html_response(profile_conn, 200) =~ "Pattern Toaster"
    end

    test "update profile renders errors when data is invalid", %{conn: conn, user: user} do
      conn =
        conn
        |> authed_conn(user)
        |> put(Routes.profile_path(conn, :update), profile: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Profile"
    end
  end

  # test "index lists all profiles", %{conn: conn} do
  #   conn = get(conn, profile_path(conn, :index))
  #   assert html_response(conn, 200) =~ "Listing Profiles"
  # end

  # describe "index" do
  #   test "lists all profiles", %{conn: conn} do
  #     conn = get(conn, profile_path(conn, :index))
  #     assert html_response(conn, 200) =~ "Listing Profiles"
  #   end
  # end
end
