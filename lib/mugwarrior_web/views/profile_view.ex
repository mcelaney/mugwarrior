defmodule MugwarriorWeb.ProfileView do
  use MugwarriorWeb, :view

  alias Mugwarrior.Membership.Profile
  alias Mugwarrior.Membership.User

  @spec display_name(Profile.t()) :: iolist | String.t()
  def display_name(%Profile{first: first, last: last}) when not (is_nil(first) or is_nil(last)) do
    [first, " ", last]
  end

  def display_name(%Profile{user: %User{username: username}}) do
    username
  end
end
