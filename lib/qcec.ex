
defmodule QCEC do
  alias QCEC.Ad
  @moduledoc """
  Documentation for QCEC.
  """
  def list_ads(:bakery), do: list_ads_by_id(1)
  def list_ads(:sushi),  do: list_ads_by_id(2)
  def list_ads(:meals),  do: list_ads_by_id(3)
  def list_ads(:all),    do: list_all_ads()

  defp list_all_ads do
    Enum.map [:bakery, :sushi, :meals], fn ad_type ->
      Task.async(fn -> list_ads(ad_type) end) |> Task.await()
    end
  end

  defp list_ads_by_id(id) do
    {:ok, {{'HTTP/1.1', 200, 'OK'}, _, body}} = id |> build_url |> :httpc.request
    {:ok, document} = Floki.parse_document(body)
    document |> Floki.find(".row") |> Enum.map(&Ad.from_document/1)
  end

  defp build_url(id) do
    'http://quilmes.gov.ar/servicios/cec.php?id_rubro=#{id}'
  end
end
