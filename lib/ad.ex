defmodule QCEC.Ad do
  defstruct image_url: nil, whatsapp: nil, title: nil, responsible: nil, city: nil

  def from_document(document) do
    image_url = image_url(document)
    whatsapp  = whatsapp(document)
    [title, city, responsible] = title_city_responsible(document)

    %QCEC.Ad{image_url: image_url, whatsapp: whatsapp, title: title, responsible: responsible, city: city}
  end

  defp image_url(document) do
    document
    |> Floki.find(".col-sm-2 img")
    |> Floki.attribute("src")
    |> Floki.text
  end

  defp whatsapp(document) do
    document
    |> Floki.find(whatsapp_selector())
    |> Floki.text
  end

  defp title_city_responsible(document) do
    [title_and_city | [responsible | _]] = document
    |> Floki.find(text_selector())
    |> Floki.text
    |> String.split("\n")
    |> Enum.map(&String.trim/1)

    case String.split(title_and_city, " - ") do
      [city] -> ["", city, responsible]
      [title, city] -> [title, city, responsible]
      [title, _, city] -> [title, city, responsible]
    end
  end

  defp whatsapp_selector do
    ".col-sm-6 a[style=\"border-radius:5px; background-color:#04B404; color:#ffffff;\"] strong"
  end

  defp text_selector do
    ".col-sm-6 strong"
  end
end
