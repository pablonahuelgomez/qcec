defmodule QCEC.Scraper do
  require Logger
  @moduledoc false

  def fetch_document(category_name) do
    Task.async(fn ->
      case fetch(category_name) do
        {:ok, category_name, document} ->
          QCEC.HTMLCacheServer.insert(category_name, document)
          Logger.info("#{category_name} inserted")

        {:error, error} ->
          {:error, error}
      end
    end)
  end

  defp fetch(category_name) do
    case QCEC.Categories.id(category_name) |> build_url |> :httpc.request() do
      {:ok, {{'HTTP/1.1', 200, 'OK'}, _, body}} ->
        {:ok, category_name, :iconv.convert("utf-8", "iso8859-1", body)}

      {:error, error} ->
        {:error, error}
    end
  end

  defp build_url(id) do
    'http://quilmes.gov.ar/servicios/cec.php?id_rubro=#{id}'
  end
end
