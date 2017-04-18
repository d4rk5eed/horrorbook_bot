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

  test "normalize/1" do
    assert Markdown.normalize("«Сядьте поудобнее. Расслабьтесь» - НЕТ") == "сядьте поудобнее расслабьтесь"
    assert Markdown.normalize("«Сядьте поудобнее. Расслабьтесь» - ДА") == "сядьте поудобнее расслабьтесь"
    assert Markdown.normalize("В УТРОБЕ (2)") == "в утробе 2"
    assert Markdown.normalize("DEUS EX MMACHINA") == "deus ex mmachina"
    assert Markdown.normalize("ГОВОРИ ДА ВСЕГДА") == "говори да всегда"
    assert Markdown.normalize("№6") == "N6"
    assert Markdown.normalize("20/18") == "20 18"
    assert Markdown.normalize("30-й километр") == "30 й километр"
    assert Markdown.normalize("32") == "32"
    assert Markdown.normalize("4, 8, 16, 32") == "4 8 16 32"
    assert Markdown.normalize("23. 4, 8, 16, 32") == "4 8 16 32"
    assert Markdown.normalize("121. «Сядьте поудобнее. Расслабьтесь» - ДА") == "сядьте поудобнее расслабьтесь"
  end
end
