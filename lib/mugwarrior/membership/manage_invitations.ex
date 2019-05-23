defmodule Mugwarrior.Membership.ManageInvitations do
  @moduledoc """
  Domain logic for managing invitations to organizations.

  These methods should be called through the Membership interface
  """

  import Ecto.Query
  alias Mugwarrior.Membership
  alias Mugwarrior.Membership.Invitation
  alias Mugwarrior.Repo

  defdelegate organization_id_from_slug(slug), to: Membership

  @spec change_invitation(Invitation.t()) :: Ecto.Changeset.t()
  def change_invitation(%Invitation{} = invitation) do
    Invitation.changeset(invitation, %{})
  end

  @spec create_invitation(String.t(), map) :: {:ok, Invitation.t()} | {:error, Ecto.Changeset.t()}
  def create_invitation(slug, attrs \\ %{}) do
    attrs = Map.put(attrs, "organization_id", organization_id_from_slug(slug))

    %Invitation{}
    |> Invitation.changeset(attrs)
    |> Repo.insert()
  end

  @spec delete_invitation(Invitation.t()) :: {:ok, Invitation.t()} | {:error, Ecto.Changeset.t()}
  def delete_invitation(%Invitation{} = invitation) do
    Repo.delete(invitation)
  end

  @spec get_invitation!(String.t(), pos_integer) :: Invitation.t() | no_return
  def get_invitation!(slug, id) do
    Invitation
    |> join(:left, [invitation], organization in assoc(invitation, :organization))
    |> where([_, organization], organization.slug == ^slug)
    |> where([invitation], invitation.id == ^id)
    |> Repo.one!()
  end
end
