defmodule QCEC.Category do
  @moduledoc """
  Category is a simple QCEC advertise structure.
  """
  defstruct name: nil, image_url: nil

  @doc "Parses a list of html_tree concurrently into a list of QCEC.Category"
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
