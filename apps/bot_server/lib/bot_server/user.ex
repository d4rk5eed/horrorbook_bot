defmodule BotServer.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :chat_id, :string
    field :active, :boolean
    field :last_touch, :utc_datetime
    field :tags, {:array, :string}
    field :created_at, :utc_datetime
    field :updated_at, :utc_datetime
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:chat_id, :active, :last_touch, :tags, :created_at, :updated_at])
    |> validate_required([:chat_id])
    |> unique_constraint(:chat_id)
  end
end
