alias QCEC.Ad

defmodule QCECTest.Ad do
  use ExUnit.Case

  test "from_document parses the ad 1 structure" do
    {:ok, file} = File.read('test/ad1.html')
    {:ok, document} = Floki.parse_document(file)

    assert Ad.from_document(document) ==
      %Ad{
        image_url: "http://intranet.quilmes.gov.ar/cec/logos_comercios/cafesur.png",
        whatsapp: "1135809005",
        title: "CAFE SUR",
        responsible: "AGUSTIN LAJCHER (responsable)",
        city: "Bernal"
      }
  end

  test "from_document parses the ad 2 structure" do
    {:ok, file} = File.read('test/ad2.html')
    {:ok, document} = Floki.parse_document(file)

    assert Ad.from_document(document) ==
      %Ad{
        image_url: "http://intranet.quilmes.gov.ar/cec/logos_comercios/68037404_20200426153234.png",
        whatsapp: "1168037404",
        title: "ARRIBA Y ABAJO",
        responsible: "SOLANGE CACERES (responsable)",
        city: "Quilmes Centro"
      }
  end

  test "from_document parses the ad 3 structure" do
    {:ok, file} = File.read('test/ad3.html')
    {:ok, document} = Floki.parse_document(file)

    assert Ad.from_document(document) ==
      %Ad{
        image_url: "http://intranet.quilmes.gov.ar/cec/logos_comercios/1166363702_20200422113800.png",
        whatsapp: "1166363702",
        title: "",
        responsible: "GABRIELA SUSANA RIVEROS ESPARZA (responsable)",
        city: "- Bernal Oeste"
      }
  end
end
