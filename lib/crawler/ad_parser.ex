defmodule QCEC.AdParser do
  def parse(document, :links) do
    document
    |> Floki.find(".col-sm-6 a")
    |> Floki.attribute("href")
  end

  def parse(document, :image_url) do
    document
    |> Floki.find(".col-sm-2 img")
    |> Floki.attribute("src")
    |> Floki.text()
  end

  def parse(document, :whatsapp) do
    document
    |> Floki.find(whatsapp_selector())
    |> Floki.text()
  end

  def parse(document, :title_city_responsible) do
    document
    |> Floki.find(text_selector())
    |> Floki.text()
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> extract_values
    |> Enum.map(&StringUtils.capitalize/1)
  end

  defp extract_values([title_and_city | [responsible | _]]) do
    case String.split(title_and_city, " - ") do
      [city] ->
        ["", format_city(city), responsible]

      [title, city] ->
        [title, format_city(city), responsible]

      [title, title2, city] ->
        ["#{title} - #{title2}", format_city(city), responsible]

      [title, title2, title3, city] ->
        ["#{title} - #{title2} - #{title3}", format_city(city), responsible]
    end
  end

  defp whatsapp_selector do
    ".col-sm-6 a[style=\"border-radius:5px; background-color:#04B404; color:#ffffff;\"] strong"
  end

  defp text_selector do
    ".col-sm-6 strong"
  end

  defp format_city(city) do
    city |> String.replace(~r/- /, "")
  end
end
