defmodule BotServer.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/hello" do
    #Agala.Bot.exec_cmd("sendMessage", %{chat_id: 127977675, parse_mode: "Markdown", text: "*i'm the lizard king!* [text](http://google.com)"})
    send_resp(conn, 200, "world")
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
