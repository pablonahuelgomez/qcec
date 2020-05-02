defmodule QCEC do
  alias QCEC.Ad
  require Logger

  @moduledoc """
  Documentation for QCEC.
  """
  def list_all_ads do
    Enum.flat_map(1..31, fn ad_category_id ->
      Task.async(fn -> list_ads_by_id(ad_category_id) end) |> Task.await()
    end)
  end

  def list_ads_by_id(id) do
    case id |> build_url |> :httpc.request() do
      {:ok, {{'HTTP/1.1', 200, 'OK'}, _, body}} -> handle_success(body)
      {:error, error} -> Logger.info(error)
    end
  end

  defp build_url(id) do
    'http://quilmes.gov.ar/servicios/cec.php?id_rubro=#{id}'
  end

  defp handle_success(body) do
    case Floki.parse_document(body) do
      {:ok, document} ->
        document
        |> Floki.find(".row")
        |> Enum.map(&Ad.from_document/1)

      {:error, error} ->
        Logger.info(error)
    end
  end
end
