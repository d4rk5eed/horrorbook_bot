defmodule BotServer.PageTest do
  use ExUnit.Case
  alias BotServer.Repo
  alias BotServer.Page

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(BotServer.Repo)
  end

  test "list/0 returns all pages" do
    Repo.insert(%Page{body: "undefined", title: "title1", url: "http://www.1.ru", tags: ["a", "b"]})
    Repo.insert(%Page{body: "undefined", title: "title2", url: "http://www.2.ru", tags: ["b", "c"]})
    Repo.insert(%Page{body: "undefined", title: "title3", url: "http://www.3.ru", tags: ["c", "d"]})

    assert length(Page.list()) == 3
    assert Map.delete(hd(Page.list()), :__meta__) == Map.delete(%Page{title: "title1", url: "http://www.1.ru", tags: ["a", "b"]}, :__meta__)
  end

  test "by_tags/1 search by tag" do
    Repo.insert(%Page{tags: ["a", "b"]})
    Repo.insert(%Page{tags: ["b", "c"]})
    Repo.insert(%Page{tags: ["c", "d"]})

    assert length(Page.by_tags("b")) == 2
    assert length(Page.by_tags("d")) == 1
  end
end
