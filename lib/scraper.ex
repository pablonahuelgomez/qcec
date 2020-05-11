defmodule QCEC.Scraper do
  @moduledoc false

  def fetch_html_pages(range \\ 1..31) do
    range
    |> Enum.map(fn id -> Task.async(fn -> fetch_html_page(id) end) end)
    |> Enum.map(fn task -> Task.await(task, :infinity) end)
  end

  defp fetch_html_page(id) do
    case id |> build_url |> :httpc.request() do
      {:ok, {{'HTTP/1.1', 200, 'OK'}, _, body}} -> body
      {:error, error} -> {:error, error}
    end
  end

  defp build_url(id) do
    'http://quilmes.gov.ar/servicios/cec.php?id_rubro=#{id}'
  end
end
