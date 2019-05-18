defmodule Mugwarrior.Membership.Profile do
  @moduledoc """
  Public information for users
  """

  use Ecto.Schema
  # use Arc.Ecto.Schema
  import Ecto.Changeset
  alias Mugwarrior.Membership.User

  @type t :: %__MODULE__{}

  schema "profiles" do
    field(:description, :string)
    field(:first, :string)
    field(:last, :string)
    field(:slug, :string)

    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  @spec init_changeset(__MODULE__.t(), map) :: Ecto.Changeset.t()
  def init_changeset(info, attrs) do
    info
    |> cast(attrs, [:user_id, :slug])
    |> validate_required([:user_id, :slug])
    |> unique_constraint(:user_id)
    |> unique_constraint(:slug)
  end

  @doc false
  @spec changeset(__MODULE__.t(), map) :: Ecto.Changeset.t()
  def changeset(info, attrs) do
    info
    |> cast(attrs, [
      :first,
      :last,
      :slug,
      :description
    ])
    |> validate_exclusion(:slug, [:edit, :new])
    |> validate_required([:first, :last, :slug])
    |> validate_exclusion(:slug, [:edit, :new])
    |> unique_constraint(:slug)
  end
end
