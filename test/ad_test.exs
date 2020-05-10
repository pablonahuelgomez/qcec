alias QCEC.Ad

defmodule QCECTest.Ad do
  use ExUnit.Case, async: true

  setup %{filename: filename} do
    {:ok, file} = File.read('test/#{filename}')
    {:ok, document} = Floki.parse_document(file)

    %{document: document}
  end

  @tag filename: 'ad1.html'
  test "from_document parses the ad 1 structure", %{document: document} do
    assert Ad.from_document(document) ==
             %Ad{
               image_url: "http://intranet.quilmes.gov.ar/cec/logos_comercios/cafesur.png",
               whatsapp: "1135809005",
               title: "Cafe Sur",
               responsible: "Agustin Lajcher (responsable)",
               city: "Bernal",
               links: [
                 "https://maps.google.com/?q=-34.7108688,-58.2800827",
                 "https://www.facebook.com/cafesurBernal1998/",
                 "https://api.whatsapp.com/send?phone=+5491135809005&text=Consulta desde Comprar en Casa - Municipio de Quilmes"
               ]
             }
  end

  @tag filename: 'ad2.html'
  test "from_document parses the ad 2 structure", %{document: document} do
    assert Ad.from_document(document) ==
             %Ad{
               image_url:
                 "http://intranet.quilmes.gov.ar/cec/logos_comercios/68037404_20200426153234.png",
               whatsapp: "1168037404",
               title: "Arriba Y Abajo - Cafe Bar",
               responsible: "Solange Caceres (responsable)",
               city: "Quilmes Centro",
               links: [
                 "https://maps.google.com/?q=-34.72073748428291,-58.25452744960784",
                 "https://www.pedidosya.com.ar/restaurantes/quilmes/arriba-y-abajo-menu",
                 "https://www.facebook.com/AyACAF%C3%89BAR-2393848580633952/?ref=bookmarks",
                 "https://www.instagram.com/arriba_abajocafebar/",
                 "https://api.whatsapp.com/send?phone=+5491168037404&text=Consulta desde Comprar en Casa - Municipio de Quilmes"
               ]
             }
  end

  @tag filename: 'ad3.html'
  test "from_document parses the ad 3 structure", %{document: document} do
    assert Ad.from_document(document) ==
             %Ad{
               image_url:
                 "http://intranet.quilmes.gov.ar/cec/logos_comercios/1166363702_20200422113800.png",
               whatsapp: "1166363702",
               title: "",
               responsible: "Gabriela Susana Riveros Esparza (responsable)",
               city: "Bernal Oeste",
               links: [
                 "https://maps.google.com/?q=-34.7238655,-58.3144188",
                 "https://api.whatsapp.com/send?phone=+5491166363702&text=Consulta desde Comprar en Casa - Municipio de Quilmes"
               ]
             }
  end

  @tag filename: 'ad4.html'
  test "from_document parses the ad 4 structure", %{document: document} do
    assert Ad.from_document(document) ==
             %Ad{
               image_url:
                 "http://intranet.quilmes.gov.ar/cec/logos_comercios/35665677_20200417180527.png",
               whatsapp: "1135665677",
               title: "Orense Alfajores",
               responsible: "Alejandro Estevez (responsable)",
               city: "Bernal",
               links: [
                 "https://maps.google.com/?q=-34.713575,-58.288414",
                 "https://www.alfajoresorense.com.ar/",
                 "https://www.instagram.com/orense.alfajores/",
                 "https://api.whatsapp.com/send?phone=+5491135665677&text=Consulta desde Comprar en Casa - Municipio de Quilmes"
               ]
             }
  end
end
