defmodule CodeCorps.StripeAccountPolicyTest do
  use CodeCorps.PolicyCase

  import CodeCorps.StripeAccountPolicy, only: [index?: 2, show?: 2]
  import CodeCorps.StripeAccount, only: [create_changeset: 2]

  alias CodeCorps.StripeAccount

  describe "index?" do
    test "returns true when user is an admin" do
      user = build(:user, admin: true)
      index = %StripeAccount{} |> request_index(%{})

      assert index?(user, changeset)
    end

    test "returns false when user is not member of organization" do
      user = insert(:user)
      organization = insert(:organization)

      changeset = %Project{} |> create_changeset(%{organization_id: organization.id})
      refute create?(user, changeset)
    end

    test "returns false when user is pending member of organization" do
      user = insert(:user)
      organization = insert(:organization)

      insert(:organization_membership, role: "pending", member: user, organization: organization)

      changeset = %Project{} |> create_changeset(%{organization_id: organization.id})
      refute create?(user, changeset)
    end

    test "returns false when user is contributor of organization" do
      user = insert(:user)
      organization = insert(:organization)

      insert(:organization_membership, role: "contributor", member: user, organization: organization)

      changeset = %Project{} |> create_changeset(%{organization_id: organization.id})
      refute create?(user, changeset)
    end

    test "returns true when user is admin of organization" do
      user = insert(:user)
      organization = insert(:organization)

      insert(:organization_membership, role: "admin", member: user, organization: organization)

      changeset = %Project{} |> create_changeset(%{organization_id: organization.id})
      assert create?(user, changeset)
    end

    test "returns true when user is owner of organization" do
      user = insert(:user)
      organization = insert(:organization)

      insert(:organization_membership, role: "owner", member: user, organization: organization)

      changeset = %Project{} |> create_changeset(%{organization_id: organization.id})
      assert create?(user, changeset)
    end
  end

  describe "update?" do
    test "returns true when user is an admin" do
      user = build(:user, admin: true)
      project = build(:project)

      assert update?(user, project)
    end

    test "returns false when user is not member of organization" do
      user = insert(:user)
      organization = insert(:organization)
      project = insert(:project, organization: organization)

      refute update?(user, project)
    end

    test "returns false when user is pending member of organization" do
      user = insert(:user)
      organization = insert(:organization)
      project = insert(:project, organization: organization)

      insert(:organization_membership, role: "pending", member: user, organization: organization)

      refute update?(user, project)
    end

    test "returns false when user is contributor of organization" do
      user = insert(:user)
      organization = insert(:organization)
      project = insert(:project, organization: organization)

      insert(:organization_membership, role: "contributor", member: user, organization: organization)

      refute update?(user, project)
    end

    test "returns true when user is admin of organization" do
      user = insert(:user)
      organization = insert(:organization)
      project = insert(:project, organization: organization)

      insert(:organization_membership, role: "admin", member: user, organization: organization)

      assert update?(user, project)
    end

    test "returns true when user is owner of organization" do
      user = insert(:user)
      organization = insert(:organization)
      project = insert(:project, organization: organization)

      insert(:organization_membership, role: "owner", member: user, organization: organization)

      assert update?(user, project)
    end
  end

  describe "stripe_auth?" do
    test "returns true when user is an admin" do
      user = build(:user, admin: true)
      project = build(:project)

      assert stripe_auth?(user, project)
    end

    test "returns false when user is not member of organization" do
      user = insert(:user)
      organization = insert(:organization)
      project = insert(:project, organization: organization)

      refute stripe_auth?(user, project)
    end

    test "returns false when user is pending member of organization" do
      user = insert(:user)
      organization = insert(:organization)
      project = insert(:project, organization: organization)

      insert(:organization_membership, role: "pending", member: user, organization: organization)

      refute stripe_auth?(user, project)
    end

    test "returns false when user is contributor of organization" do
      user = insert(:user)
      organization = insert(:organization)
      project = insert(:project, organization: organization)

      insert(:organization_membership, role: "contributor", member: user, organization: organization)

      refute stripe_auth?(user, project)
    end

    test "returns false when user is admin of organization" do
      user = insert(:user)
      organization = insert(:organization)
      project = insert(:project, organization: organization)

      insert(:organization_membership, role: "admin", member: user, organization: organization)

      refute stripe_auth?(user, project)
    end

    test "returns false when user is owner of organization" do
      user = insert(:user)
      organization = insert(:organization)
      project = insert(:project, organization: organization)

      insert(:organization_membership, role: "owner", member: user, organization: organization)

      assert stripe_auth?(user, project)
    end
  end
end
