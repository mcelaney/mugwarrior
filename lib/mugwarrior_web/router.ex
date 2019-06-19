defmodule MugwarriorWeb.Router do
  use MugwarriorWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :guardian do
    plug(MugwarriorWeb.Guardian.Plug)
    plug(MugwarriorWeb.Guardian.CurrentUserPlug)
  end

  pipeline :ensure_auth do
    plug(Guardian.Plug.EnsureAuthenticated)
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MugwarriorWeb do
    pipe_through([:browser, :guardian, :ensure_auth])

    resources("/profile", ProfileController, only: [:edit, :update], singleton: true)
    resources("/members", ProfileController, only: [:index, :show])
    get("/dashboard", PageController, :dashboard)

    resources("/swap_groups", Membership.OrganizationController,
      only: [:new, :create],
      as: :membership_organization
    )

    resources "/o", OrganizationController, only: [:show] do
      resources "/invitation", InvitationController
      get("/change_membership/:profile_id", ProfileController, :update, as: :role_change)
    end
  end

  scope "/", MugwarriorWeb do
    # Use the default browser stack
    pipe_through([:browser, :guardian])

    get("/", PageController, :index)
  end

  scope "/signup", MugwarriorWeb.Signup, as: :signup do
    pipe_through([:browser, :guardian])

    resources("/", UserController, only: [:new, :create])
  end

  scope "/", MugwarriorWeb.Auth, as: :auth do
    pipe_through([:browser, :guardian, :ensure_auth])
    post("/logout", UserController, :delete)
  end

  scope "/auth", MugwarriorWeb.Auth, as: :auth do
    pipe_through([:browser, :guardian])

    resources("/", UserController, only: [:new, :create])
  end

  # Other scopes may use custom stacks.
  # scope "/api", MugwarriorWeb do
  #   pipe_through :api
  # end
end
