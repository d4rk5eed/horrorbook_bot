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
end
