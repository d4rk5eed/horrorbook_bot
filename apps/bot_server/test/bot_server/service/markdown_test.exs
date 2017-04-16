defmodule BotServer.MarkdownTest do
  use ExUnit.Case
  alias BotServer.Service.Markdown

  test "decorate" do
    pages =[
      %{
        tags: ["a", "b"],
        title: "title1",
        url: "http://www.1.ru"
      },
      %{
        tags: ["c", "d"],
        title: "title2",
        url: "http://www.2.ru"
      }
    ]
    assert Markdown.decorate(pages) == "[title1](http://www.1.ru)\n_a, b_\n\n[title2](http://www.2.ru)\n_c, d_\n\n"
  end

  test "decorate_item/1" do
    page = %{
      tags: ["a", "b"],
      title: "title1",
      url: "http://www.1.ru"
    }
    assert Markdown.decorate_item(page) == "[title1](http://www.1.ru)\n_a, b_\n\n"
  end

  test "split/2" do
    list = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    assert Markdown.split(list) == [[1, 2, 3, 4, 5], [6, 7, 8, 9, 10], [11, 12]]
  end
end
