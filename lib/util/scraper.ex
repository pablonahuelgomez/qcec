defmodule QCEC.Scraper do
  require Logger
  @moduledoc false

  def fetch_document(category) do
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
