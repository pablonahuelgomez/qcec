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

  defp parse(document, section) do
    QCEC.CategoryParser.parse(document, section)
  end
end
