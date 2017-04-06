defmodule BotServer.Router do
  use Plug.Router

  plug Plug.Parsers, parsers: [:urlencoded, :multipart]
  plug :match
  plug :dispatch

  post "/push" do
    Agala.Bot.exec_cmd("sendMessage", %{chat_id: 127977675, parse_mode: "Markdown", text: conn.body_params["text"]})
    send_resp(conn, 200, "ok")
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
