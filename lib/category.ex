defmodule QCEC.Category do
  @moduledoc """
  Category is a simple QCEC advertise structure.
  """
  defstruct name: nil, image_url: nil, local_name: nil

  @doc "Parses a list of html_tree concurrently into a list of QCEC.Category"
  def from_document(document, category_name) do
    %QCEC.Category{
      name: parse(document, :name),
      image_url: parse(document, :image_url),
      local_name: category_name
    }
  end

  defp parse(document, :name) do
    document
    |> Floki.find("h1[style=\"color:#ffffff\"]")
    |> Floki.text()
    |> String.trim()
  end

  defp parse(document, :image_url) do
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
