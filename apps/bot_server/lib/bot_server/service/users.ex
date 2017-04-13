defmodule BotServer.Service.Users do
  alias BotServer.Repo
  alias BotServer.User

  def upsert(%{chat_id: chat_id}) do
    utc_now = DateTime.utc_now
    changeset = %User{
      chat_id: to_string(chat_id),
      active: true,
      created_at: utc_now
    }

    changes = %{
      updated_at: utc_now,
      last_touch: utc_now
    }
    result =
      case Repo.get_by(User, chat_id: to_string(chat_id)) do
        nil  -> changeset
        user -> user
      end
      |> User.changeset(changes)
      |> Repo.insert_or_update

    case result do
      {:ok, struct}       -> {:ok, struct} # Inserted or updated with success
      {:error, changeset} -> {:error, changeset}
    end
  end
end
