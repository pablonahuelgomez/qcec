defmodule QCEC.Parser do
  @moduledoc """
  Parses html_tree into QCEC structures.
  """
  require Logger
  alias QCEC.Ad
  alias QCEC.AdCacheServer

  def parse_ads(document, category_name) do
    Task.async(fn ->
      parse(:ads, document, category_name) |> AdCacheServer.insert(category_name)
      Logger.info("#{category_name} parsed")
    end)
  end

  defp parse(:ads, document, category_name) do
    case Floki.parse_document(document) do
      {:ok, document} -> extract_ads(document, category_name)
      {:error, error} -> {:error, error}
    end
  end

  defp extract_ads(document, category_name) do
    document
    |> Floki.find(".row")
    |> Enum.map(fn row -> Ad.from_document(row, category_name) end)
  end
end
