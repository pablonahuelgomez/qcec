defmodule QCEC.Ad do
  @moduledoc """
  Ad is a simple QCEC advertise structure.
  """
  @derive Jason.Encoder
  defstruct image_url: nil,
            whatsapp: nil,
            title: nil,
            responsible: nil,
            city: nil,
            links: nil,
            category_name: nil,
            address: nil

  @doc "Transform a html_tree into an ad."
  def from_document(document, category_name) do
    [title, city, responsible] = parse(document, :title_city_responsible)

    %QCEC.Ad{
      image_url: parse(document, :image_url),
      whatsapp: parse(document, :whatsapp),
      title: StringUtils.raw_binary_to_string(title),
      responsible: StringUtils.raw_binary_to_string(responsible),
      city: StringUtils.raw_binary_to_string(city),
      links: parse(document, :links),
      category_name: category_name,
      address: parse(document, :address)
    }
  end

  defp parse(document, section) do
    QCEC.AdParser.parse(document, section)
  end
end
