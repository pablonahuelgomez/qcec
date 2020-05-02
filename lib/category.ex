defmodule QCEC.Category do
  defstruct name: nil, description: nil, external_id: nil, image_url: nil

  def from_document(document) do
    %QCEC.Category{
      name: name(document),
      image_url: image_url(document)
    }
  end

  defp name(document) do
    document
    |> Floki.find("h1[style=\"color:#ffffff\"]")
    |> Floki.text()
    |> String.trim()
  end

  defp image_url(document) do
    path = document
    |> Floki.find("img")
    |> Floki.attribute("src")
    |> Floki.text()

    "https://quilmes.gov.ar/servicios/#{path}"
  end
end
