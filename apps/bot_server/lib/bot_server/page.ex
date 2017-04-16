defmodule BotServer.Page do
  use Ecto.Schema
  import Ecto.Query
  alias BotServer.Page

  schema "pages" do
    field :url, :string
    field :body, :string
    field :title, :string

    field :tags, {:array, :string}
    field :created_at, :utc_datetime
    field :updated_at, :utc_datetime
  end

  def by_tags(tag) do
    query = from p in Page, where: ^tag in p.tags
    BotServer.Repo.all(query)
  end

  def list() do
    query = from p in Page, select: [:title, :url, :tags]
    BotServer.Repo.all(query)
  end

  def list(%{tags: tag}) do
    query = from p in Page, where: ^tag in p.tags, select: [:title, :url, :tags]
    BotServer.Repo.all(query)
  end
end
