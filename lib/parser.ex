defmodule QCEC.Parser do
  @moduledoc """
  Parses html_tree into QCEC structures.
  """

  alias QCEC.Ad
  alias QCEC.Category

  @doc "Parses a list of html_tree concurrently into a list of QCEC.Ad"
  def parse_ads(htmls) do
    htmls
    |> Enum.map(fn {category_name, html} ->
      Task.async(fn -> parse(:ads, html, category_name) end)
    end)
    |> Enum.flat_map(fn task -> Task.await(task, :infinity) end)
  end

  @doc "Parses a list of html_tree concurrently into a list of QCEC.Ad"
  def parse_categories(htmls) do
    htmls
    |> Enum.map(fn {category_name, html} ->
      Task.async(fn -> parse(:category, html, category_name) end)
    end)
    |> Enum.map(fn task -> Task.await(task, :infinity) end)
  end

  defp parse(:category, html, category_name) do
    case Floki.parse_document(html) do
      {:ok, document} -> extract_category(document, category_name)
      {:error, error} -> {:error, error}
    end
  end

  defp parse(:ads, htmls, category_name) do
    case Floki.parse_document(htmls) do
      {:ok, document} -> extract_ads(document, category_name)
      {:error, error} -> {:error, error}
    end
  end

  defp extract_category(document, category_name) do
    document
    |> Floki.find("table[style=\"background-color: #783884\"")
    |> Category.from_document(category_name)
  end

  defp extract_ads(document, category_name) do
    document
    |> Floki.find(".row")
    |> Enum.map(fn row -> Ad.from_document(row, category_name) end)
  end
end
