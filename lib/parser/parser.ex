defmodule QCEC.Parser do
  @moduledoc """
  Parses html_tree into QCEC structures.
  """
  alias QCEC.Ad
  alias QCEC.AdCacheServer, as: Cache

  def parse_ads(document, category_name) do
    Task.async(fn ->
      case Cache.lookup(category_name) do
        nil ->
          parse(:ads, document, category_name)
          |> Cache.insert(category_name)

        ads ->
          ads
      end

      Phoenix.PubSub.broadcast(QCEC.PubSub, "ads", {:category_parsed, %{category: category_name}})
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
