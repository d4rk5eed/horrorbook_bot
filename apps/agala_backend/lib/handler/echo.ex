defmodule AgalaBackend.Handler.Echo do
  use Agala.Handler
  require Logger

  def state do
    []
  end

  def handle(state, message = %{"message" => %{"text" => "/start", "chat" => %{"id" => id}}}) do
    Logger.info("Handling message #{inspect message}")
    BotServer.Service.Users.upsert(%{chat_id: id})
    state
  end

  def handle(state, message = %{"message" => %{"text" => "/list", "chat" => %{"id" => id}}}) do
    Logger.info("Handling message #{inspect message}")
    pages = BotServer.Service.Markdown.split(BotServer.Page.list())
    show_pages pages, id
    state
  end

  def handle(state, message = %{"message" => %{"text" => "/list "<>tag, "chat" => %{"id" => id}}}) do
    Logger.info("Handling message #{inspect message}")
    pages = BotServer.Service.Markdown.split(BotServer.Page.list(%{tags: BotServer.Service.Markdown.normalize(tag)}))
    show_pages pages, id
    state
  end

  def handle(state, message = %{"message" => %{"text" => "/add", "chat" => %{"id" => id}}}) do
    Logger.info("Handling message #{inspect message}")
    tags = BotServer.Service.Users.list_tags_for(%{chat_id: id})
    show_tags_for id, tags
    state
  end

  def handle(state, message = %{"message" => %{"text" => "/add "<>tag, "chat" => %{"id" => id}}}) do
    Logger.info("Handling message #{inspect message}")
    case BotServer.Service.Users.add_tag_for(%{chat_id: id, tag: BotServer.Service.Markdown.normalize(tag)}) do
      nil -> show_error_for id, "Не удалось добавить рассказ"
      _user ->
        tags = BotServer.Service.Users.list_tags_for(%{chat_id: id})
        show_tags_for id, tags
    end

   state
  end

  def handle(state, message = %{"message" => %{"text" => text, "chat" => %{"id" => id}}}) do
    Logger.info("Handling message #{inspect message}")
    Agala.Bot.exec_cmd("sendMessage", %{chat_id: id, text: text})
    state
  end

  defp show_pages([], chat_id) do
    Agala.Bot.exec_cmd("sendMessage", %{chat_id: chat_id, parse_mode: "Markdown", text: "Ничего не найдено, но ваше время обязательно придет"})
  end

  defp show_pages(pages, chat_id) do
    Enum.each pages, fn(p) ->
      Agala.Bot.exec_cmd("sendMessage", %{chat_id: chat_id, parse_mode: "Markdown", text: BotServer.Service.Markdown.decorate(p)})
    end
  end

  defp show_tags_for(chat_id, []) do
    Agala.Bot.exec_cmd("sendMessage", %{chat_id: chat_id, parse_mode: "Markdown", text: "Вы не отслеживаете ни один из рассказов"})
  end

  defp show_tags_for(chat_id, tags) do
    Agala.Bot.exec_cmd("sendMessage", %{chat_id: chat_id, parse_mode: "Markdown", text: Enum.join(tags, ", ")})
  end

  defp show_error_for(chat_id, error) do
    Agala.Bot.exec_cmd("sendMessage", %{chat_id: chat_id, parse_mode: "Markdown", text: error})
  end
end
