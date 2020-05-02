defmodule QCEC do
  alias QCEC.Ad
  alias QCEC.Category
  require Logger

  @moduledoc """
  Documentation for QCEC.
  """
  def list_all_ads do
    Enum.flat_map(1..31, fn ad_category_id ->
      Task.async(fn -> list_ads_by_id(ad_category_id) end) |> Task.await()
    end)
  end

  def list_all_categories do
    Enum.map(1..31, fn category_id ->
      Task.async(fn -> category_by_id(category_id) end) |> Task.await()
    end)
  end

  def list_ads_by_id(id) do
    fetch_with_handler(id, &extract_ad/1)
  end

  def category_by_id(id) do
    fetch_with_handler(id, &extract_category/1)
  end

  defp fetch_with_handler(id, handler) do
    case id |> build_url |> :httpc.request() do
      {:ok, {{'HTTP/1.1', 200, 'OK'}, _, body}} ->
        handle_success(body, handler)
      {:error, error} ->
        Logger.info(error)
    end
  end

  defp build_url(id) do
    'http://quilmes.gov.ar/servicios/cec.php?id_rubro=#{id}'
  end

  defp handle_success(body, handler) do
    case Floki.parse_document(body) do
      {:ok, document} ->
        handler.(document)
      {:error, error} ->
        Logger.info(error)
    end
  end

  defp extract_category(document) do
    document
    |> Floki.find("table[style=\"background-color: #783884\"")
    |> Category.from_document()
  end

  defp extract_ad(document) do
    document
    |> Floki.find(".row")
    |> Enum.map(&Ad.from_document/1)
  end
end
