defmodule Mugwarrior.Membership.ManageRoles do
  @moduledoc """
  Domain logic for managing the roles users have within organizations.

  These methods should be called through the Membership interface
  """

  import Ecto.Query
  alias Mugwarrior.Membership.Organization
  alias Mugwarrior.Membership.OrganizationProfile
  alias Mugwarrior.Membership.Profile
  alias Mugwarrior.Membership.User
  alias Mugwarrior.Repo

  @doc """
  Returns a boolean indicating whether the given admin can be demoted.

  We only allow a demotion if there is another admin in teh organization

  iex> can_demote_admins?(profile)
  true
  """
  @spec can_demote_admins?(Organization.t(), User.t()) :: boolean
  def can_demote_admins?(org, user) do
    org
    |> is_organization_admin?(user)
    |> Kernel.&&(has_multiple_admins?(org))
  end

  @doc """
  Promotes a given profile to an admin for a given a organization.

  The org/profile relationship needs to already exist for this to work

  ## Examples

      iex> demote_profile_to_org_member(profile, organization)
      {:ok, organization}

  """
  @spec demote_profile_to_org_member(Profile.t() | map, Organization.t()) ::
          {:ok, Organization.t()} | no_return()
  def demote_profile_to_org_member(%{id: profile_id}, %Organization{id: org_id} = org) do
    with {:ok, _} <- change_profile_role(profile_id, org_id, OrganizationProfile.member_role()) do
      {:ok, org}
    else
      _ ->
        raise RuntimeError,
          message: "Could not promote profile (#{profile_id}) to admin on org (#{org_id})"
    end
  end

  @doc """
  Returns a boolean indicating whether the given string matched the expected
    admin value

  iex> is_organization_admin?("admin")
  true
  """
  @spec is_organization_admin?(String.t()) :: boolean
  def is_organization_admin?(role), do: role == OrganizationProfile.admin_role()

  @doc """
  Returns a boolean indicating whether the given user is an admin of the given org

  iex> is_organization_admin?(%Organziation{}, %User{})
  true
  """
  @spec is_organization_admin?(Organization.t(), map) :: boolean
  def is_organization_admin?(org, %{profile: profile}) do
    OrganizationProfile
    |> where([org_profile], org_profile.organization_id == ^org.id)
    |> where([org_profile], org_profile.profile_id == ^profile.id)
    |> select(
      [org_profile],
      coalesce(org_profile.role == ^OrganizationProfile.admin_role(), false)
    )
    |> Repo.one()
  end

  @doc """
  Promotes a given profile to an admin for a given a organization.

  The org/profile relationship needs to already exist for this to work

  ## Examples

      iex> promote_profile_to_org_admin(profile, organization)
      {:ok, organization}

  """
  @spec promote_profile_to_org_admin(Profile.t() | map, Organization.t()) ::
          {:ok, Organization.t()} | no_return()
  def promote_profile_to_org_admin(%{id: profile_id}, %Organization{id: org_id} = org) do
    with {:ok, _} <- change_profile_role(profile_id, org_id, OrganizationProfile.admin_role()) do
      {:ok, org}
    else
      _ ->
        raise RuntimeError,
          message: "Could not promote profile (#{profile_id}) to admin on org (#{org_id})"
    end
  end

  @spec change_profile_role(pos_integer, pos_integer, String.t()) ::
          {:ok, Organization.t()} | {:error, Organization.t()}
  defp change_profile_role(profile_id, org_id, role) do
    OrganizationProfile
    |> where([op], op.profile_id == ^profile_id and op.organization_id == ^org_id)
    |> Repo.one()
    |> OrganizationProfile.changeset(%{role: role})
    |> Repo.update()
  end

  @spec has_multiple_admins?(Organization.t()) :: boolean
  defp has_multiple_admins?(org) do
    OrganizationProfile
    |> where([org_profile], org_profile.organization_id == ^org.id)
    |> where([org_profile], org_profile.role == ^OrganizationProfile.admin_role())
    |> select([org_profile], count(org_profile.profile_id) > 1)
    |> Repo.one()
  end
end
