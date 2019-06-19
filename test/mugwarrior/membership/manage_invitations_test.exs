defmodule Mugwarrior.Membership.ManageInvitationsTest do
  use Mugwarrior.DataCase
  alias Mugwarrior.Membership
  alias Mugwarrior.Membership.Invitation
  alias Mugwarrior.Membership.Organization
  alias Mugwarrior.Repo

  test "change_invitation/1" do
    result = Membership.change_invitation(%Invitation{})
    assert %Ecto.Changeset{} = result
  end

  describe "given an organization exists" do
    setup do
      org = %Organization{slug: "think", name: "Think Company"} |> Repo.insert!()

      [org: org]
    end

    test "create_invitation/2, get_invitation!/2, delete_invitation/1", %{org: org} do
      {:ok, result} = Membership.create_invitation(org.slug, %{"email" => "jawn@philly.com"})

      assert %Invitation{} = result

      invitation = Membership.get_invitation!(org.slug, result.id)

      assert invitation.email == "jawn@philly.com"

      Membership.delete_invitation(invitation)

      assert_raise Ecto.NoResultsError, fn ->
        Membership.get_invitation!(org.slug, result.id)
      end
    end
  end
end
