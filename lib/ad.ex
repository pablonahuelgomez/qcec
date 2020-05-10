defmodule QCEC.Ad do
  defstruct image_url: nil, whatsapp: nil, title: nil, responsible: nil, city: nil, links: nil

  def from_document(document) do
    [title, city, responsible] = title_city_responsible(document)

    %QCEC.Ad{
      image_url: image_url(document),
      whatsapp: whatsapp(document),
      title: title,
      responsible: responsible,
      city: city,
      links: links(document)
    }
  end

  defp links(document) do
    document
    |> Floki.find(".col-sm-6 a")
    |> Floki.attribute("href")
  end

  defp image_url(document) do
    document
    |> Floki.find(".col-sm-2 img")
    |> Floki.attribute("src")
    |> Floki.text()
  end

  defp whatsapp(document) do
    document
    |> Floki.find(whatsapp_selector())
    |> Floki.text()
  end

  defp title_city_responsible(document) do
    [title_and_city | [responsible | _]] =
      document
      |> Floki.find(text_selector())
      |> Floki.text()
      |> String.split("\n")
      |> Enum.map(&String.trim/1)

    result = case String.split(title_and_city, " - ") do
      [city] ->
        ["", format_city(city), responsible]

      [title, city] ->
        [title, format_city(city), responsible]

      [title, title2, city] ->
        ["#{title} - #{title2}", format_city(city), responsible]

      [title, title2, title3, city] ->
        ["#{title} - #{title2} - #{title3}", format_city(city), responsible]
    end

    result |> Enum.map(&capitalize/1)
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

  defp capitalize(text) do
    text
    |> String.split()
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end
end
