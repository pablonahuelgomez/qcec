defmodule QCEC.Parser do
  alias QCEC.Ad
  alias QCEC.Category

  def parse_ads(htmls) do
    htmls
    |> Enum.map(fn html -> Task.async(fn -> get_ads(html) end) end)
    |> Enum.flat_map(fn task -> Task.await(task, :infinity) end)
  end

  def parse_categories(htmls) do
    htmls
    |> Enum.map(fn html -> Task.async(fn -> get_category(html) end) end)
    |> Enum.map(fn task -> Task.await(task, :infinity) end)
  end

  defp get_category(html) do
    case Floki.parse_document(html) do
      {:ok, document} -> extract_category(document)
      {:error, error} -> {:error, error}
    end
  end

  defp get_ads(html) do
    case Floki.parse_document(html) do
      {:ok, document} -> extract_ads(document)
      {:error, error} -> {:error, error}
    end
  end

  defp extract_category(document) do
    document
    |> Floki.find("table[style=\"background-color: #783884\"")
    |> Category.from_document()
  end

  defp extract_ads(document) do
    document
    |> Floki.find(".row")
    |> Enum.map(&Ad.from_document/1)
  end
end
