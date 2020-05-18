defmodule QCEC.Scraper do
  @moduledoc false

  def fetch_html_pages do
    QCEC.Categories.list()
    |> Enum.map(fn {category_name, id} -> Task.async(fn -> fetch_html_page(category_name, id) end) end)
    |> Enum.map(fn task -> Task.await(task, :infinity) end)
  end

  defp fetch_html_page(category_name, id) do
    case id |> build_url |> :httpc.request() do
      {:ok, {{'HTTP/1.1', 200, 'OK'}, _, body}} -> {category_name, body}
      {:error, error} -> {:error, error}
    end
  end

  defp build_url(id) do
    'http://quilmes.gov.ar/servicios/cec.php?id_rubro=#{id}'
  end
end
