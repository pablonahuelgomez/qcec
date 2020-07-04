defmodule QCEC.Scraper do
  require Logger
  @moduledoc false

  def fetch_document(category) do
    Task.async(fn ->
      case fetch(category) do
        {:ok, category, document} ->
          QCEC.HTMLCacheServer.insert(category, document)
          Phoenix.PubSub.broadcast(QCEC.PubSub, "ads", {:category_fetched, %{category: category}})

        {:error, error} ->
          {:error, error}
      end
    end)
  end

  defp fetch(category) do
    case QCEC.Categories.id(category) |> build_url |> :httpc.request() do
      {:ok, {{'HTTP/1.1', 200, 'OK'}, _, body}} ->
        {:ok, category, :iconv.convert("utf-8", "iso8859-1", body)}

      {:error, error} ->
        {:error, error}
    end
  end

  defp build_url(id) do
    'http://quilmes.gov.ar/servicios/cec.php?id_rubro=#{id}'
  end
end
