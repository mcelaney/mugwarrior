defmodule Mugwarrior.Membership do
  @moduledoc """
  Context responsible for managing profile information
  """

  import Ecto.Query
  alias Mugwarrior.Membership.Profile
  alias Mugwarrior.Membership.User
  alias Mugwarrior.Repo

  @spec get_user(pos_integer | String.t()) :: {:ok, User.t()} | nil
  def get_user(id) do
    User
    |> preload([:profile])
    |> where([user], user.id == ^id)
    |> Repo.one()
  end

  @doc """
  Returns the list of profiles.

  ## Examples

      iex> list_profiles()
      [%Profile{}, ...]

  """
  @spec list_profiles :: list(Profile.t())
  def list_profiles do
    Profile
    |> order_by(:last)
    |> Repo.all()
  end

  @doc """
  Gets a single profile.

  Raises `Ecto.NoResultsError` if the Profile does not exist.

  ## Examples

      iex> get_profile!(123)
      %Profile{}

      iex> get_profile!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_profile!(pos_integer | String.t()) :: Profile.t()
  def get_profile!(id) when is_integer(id), do: Repo.get!(Profile, id)

  def get_profile!(slug) do
    Profile
    |> where([profile], profile.slug == ^slug)
    |> Repo.one!()
  end

  @doc """
  Updates a profile.

  ## Examples

      iex> update_profile(profile, %{field: new_value})
      {:ok, %Profile{}}

      iex> update_profile(profile, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_profile(User.t(), map) :: {:ok, Profile.t()} | {:error, Ecto.Changeset.t()}
  def update_profile(%User{profile: profile}, params) when not is_nil(profile) do
    profile
    |> Profile.changeset(params)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking profile changes.

  Expects a Membership.User.  If the User has a profile the changeset will be
  for that profile.  Otherwise this method will generate a new profile for the
  user.

  ## Examples

      iex> change_profile(profile)
      %Ecto.Changeset{source: %Profile{}}

  """
  @spec change_profile(User.t()) :: Ecto.Changeset.t()
  def change_profile(%User{profile: profile}) when not is_nil(profile) do
    Profile.changeset(profile, %{})
  end

  def change_profile(user) do
    %Profile{}
    |> Profile.init_changeset(%{user_id: user.id, slug: "user_#{user.id}"})
    |> Repo.insert!()
    |> Profile.changeset(%{})
  end
end
