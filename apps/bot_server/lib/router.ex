defmodule BotServer.Router do
  use Plug.Router

  plug Plug.Parsers, parsers: [:urlencoded, :json],
    pass:  ["text/*"],
    json_decoder: Poison
  plug :match
  plug :dispatch

  post "/push" do
    for {k, x} <- conn.params do
      Agala.Bot.exec_cmd("sendMessage", %{chat_id: k, parse_mode: "Markdown", text: x})
    end
    send_resp(conn, 200, "ok")
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
