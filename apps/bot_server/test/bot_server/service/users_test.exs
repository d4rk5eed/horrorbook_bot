defmodule BotServer.Service.UsersTest do
  use ExUnit.Case
  alias BotServer.Repo
  alias BotServer.Service.Users
  alias BotServer.User

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(BotServer.Repo)
  end

  test "upsert insert new" do
    {:ok, _} = Users.upsert(%{chat_id: 123456})
    assert %User{} = Repo.get_by(User, chat_id: "123456")
  end

  test "upsert not insert the same" do
    Users.upsert(%{chat_id: 123456})
    Users.upsert(%{chat_id: 123456})
    assert 1 = Repo.aggregate(User, :count, :chat_id)
  end

  test "created_at , updated_at" do
    Users.upsert(%{chat_id: 123456})
    user = Repo.get_by(User, chat_id: "123456")
    assert %DateTime{} = user.created_at
    assert %DateTime{} = user.updated_at
  end

  test "last_touch" do
    {:ok, user} = Users.upsert(%{chat_id: 123456})
    touch_prev = user.last_touch
    updated_prev = user.updated_at

    assert %DateTime{} = touch_prev
    {:ok, user} = Users.upsert(%{chat_id: 123456})
    refute touch_prev == user.last_touch
    refute updated_prev == user.updated_at
  end

  test "list_tags_for on empty" do
    %User{chat_id: "123"}
    |> User.changeset
    |> Repo.insert
    assert Users.list_tags_for(%{chat_id: "123"}) == []
  end

  test "list_tags_for on existing tags" do
    %User{chat_id: "123", tags: ["a", "b"]}
    |> User.changeset
    |> Repo.insert
    assert Users.list_tags_for(%{chat_id: "123"}) == ["a", "b"]
  end

  test "add_tag_for on empty and existing tags" do
    %User{chat_id: "123"}
    |> User.changeset
    |> Repo.insert
    assert %User{} = Users.add_tag_for(%{chat_id: "123", tag: "a"})
    assert %User{} = Users.add_tag_for(%{chat_id: "123", tag: "b"})
    assert Users.list_tags_for(%{chat_id: "123"}) == ["a", "b"]
  end

  test "add_tag_for on duplicate tags" do
    %User{chat_id: "123", tags: ["a", "b"]}
    |> User.changeset
    |> Repo.insert
    assert %User{} = Users.add_tag_for(%{chat_id: "123", tag: "a"})
    assert Users.list_tags_for(%{chat_id: "123"}) == ["a", "b"]
  end

  test "del_tag_from user existing tag" do
    %User{chat_id: "123", tags: ["a", "b"]}
    |> User.changeset
    |> Repo.insert
    assert %User{} = Users.del_tag_from(%{chat_id: "123", tag: "a"})
    assert Users.list_tags_for(%{chat_id: "123"}) == ["b"]
  end

  test "del_tag_from user non-existing tag" do
    %User{chat_id: "123", tags: ["a", "b"]}
    |> User.changeset
    |> Repo.insert
    assert %User{} = Users.del_tag_from(%{chat_id: "123", tag: "c"})
    assert Users.list_tags_for(%{chat_id: "123"}) == ["a", "b"]
  end
end
