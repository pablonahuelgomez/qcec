defmodule QCEC.CategoryParser do
  def parse(document, :name) do
    document
    |> Floki.find("h1[style=\"color:#ffffff\"]")
    |> Floki.text()
    |> String.trim()
  end

  def parse(document, :image_url) do
    document
    |> Floki.find("img")
    |> Floki.attribute("src")
    |> Floki.text()
    |> build_url()
  end

  defp build_url(path) do
    "https://quilmes.gov.ar/servicios/#{path}"
  end
end
