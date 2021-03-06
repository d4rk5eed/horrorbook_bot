defmodule BotServer.Service.Markdown do
  def decorate(pages) do
    Enum.join Enum.map(pages, fn(x) ->  decorate_item(x) end)
  end

  def decorate_item(page) do
    tags = Enum.join(page.tags, ", ")
    "[#{page.title}](#{page.url})\n_#{tags}_\n\n"
  end

  def split(list) do
    split(list, [])
  end

  def split([], acc) do
    acc
  end

  def split(list, acc) do
    {h, t} = Enum.split(list, 5)
    split(t, acc ++ [h])
  end

  def normalize(text) do
    text
    |> String.downcase
    |> String.replace(~r/^\d+\.\s/, "")
    |> String.replace(~r/№/, "N")
    |> String.replace(~r/[^\w\s\p{Cyrillic}]+/u, " ")
    |> String.replace(~r/\s{2,}/, " ")
    |> String.replace("ё", "е")
    |> String.replace(~r/\sда$|\sнет$/u, "")
    |> String.trim
  end
end
