defmodule QCEC.Parser do
  @moduledoc """
  Parses html_tree into QCEC structures.
  """
  alias QCEC.Ad
  alias QCEC.AdCacheServer, as: Cache

  def parse_ads(document, category) do
    case Cache.lookup(category) do
      nil ->
        parse(:ads, document, category)
        |> Cache.insert(category)

      ads ->
        ads
    end
  end

  defp parse(:ads, document, category) do
    case Floki.parse_document(document) do
      {:ok, document} -> extract_ads(document, category)
      {:error, error} -> {:error, error}
    end
  end

  defp extract_ads(document, category) do
    document
    |> Floki.find(".row")
    |> Enum.map(fn row -> Ad.from_document(row, category) end)
  end
end
