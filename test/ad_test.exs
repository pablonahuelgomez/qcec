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
    assert Ad.from_document(document, :category) ==
             %Ad{
               address: "",
               image_url: "http://intranet.quilmes.gov.ar/cec/logos_comercios/cafesur.png",
               whatsapp: "1135809005",
               title: "Cafe Sur",
               responsible: "Agustin Lajcher (responsable)",
               city: "Bernal",
               links: [
                 %{link: "https://maps.google.com/?q=-34.7108688,-58.2800827", type: "google"},
                 %{link: "https://www.facebook.com/cafesurBernal1998/", type: "facebook"},
                 %{
                   link:
                     "https://api.whatsapp.com/send?phone=+5491135809005&text=Consulta desde Comprar en Casa - Municipio de Quilmes",
                   type: "whatsapp"
                 }
               ],
               category_name: :category
             }
  end

  @tag filename: 'ad2.html'
  test "from_document parses the ad 2 structure", %{document: document} do
    assert Ad.from_document(document, :category) ==
             %Ad{
               address: "Av. Mitre 603",
               image_url:
                 "http://intranet.quilmes.gov.ar/cec/logos_comercios/68037404_20200426153234.png",
               whatsapp: "1168037404",
               title: "Arriba Y Abajo - Cafe Bar",
               responsible: "Solange Caceres (responsable)",
               city: "Quilmes Centro",
               links: [
                 %{
                   link: "https://maps.google.com/?q=-34.72073748428291,-58.25452744960784",
                   type: "google"
                 },
                 %{
                   link: "https://www.pedidosya.com.ar/restaurantes/quilmes/arriba-y-abajo-menu",
                   type: "pedidosya"
                 },
                 %{
                   link:
                     "https://www.facebook.com/AyACAF%C3%89BAR-2393848580633952/?ref=bookmarks",
                   type: "facebook"
                 },
                 %{link: "https://www.instagram.com/arriba_abajocafebar/", type: "instagram"},
                 %{
                   link:
                     "https://api.whatsapp.com/send?phone=+5491168037404&text=Consulta desde Comprar en Casa - Municipio de Quilmes",
                   type: "whatsapp"
                 }
               ],
               category_name: :category
             }
  end

  @tag filename: 'ad3.html'
  test "from_document parses the ad 3 structure", %{document: document} do
    assert Ad.from_document(document, :category) ==
             %Ad{
               address: "",
               image_url:
                 "http://intranet.quilmes.gov.ar/cec/logos_comercios/1166363702_20200422113800.png",
               whatsapp: "1166363702",
               title: "",
               responsible: "Gabriela Susana Riveros Esparza (responsable)",
               city: "Bernal Oeste",
               links: [
                 %{link: "https://maps.google.com/?q=-34.7238655,-58.3144188", type: "google"},
                 %{
                   link:
                     "https://api.whatsapp.com/send?phone=+5491166363702&text=Consulta desde Comprar en Casa - Municipio de Quilmes",
                   type: "whatsapp"
                 }
               ],
               category_name: :category
             }
  end

  @tag filename: 'ad4.html'
  test "from_document parses the ad 4 structure", %{document: document} do
    assert Ad.from_document(document, :category) ==
             %Ad{
               address: "Avellaneda 438",
               image_url:
                 "http://intranet.quilmes.gov.ar/cec/logos_comercios/35665677_20200417180527.png",
               whatsapp: "1135665677",
               title: "Orense Alfajores",
               responsible: "Alejandro Estevez (responsable)",
               city: "Bernal",
               links: [
                 %{link: "https://maps.google.com/?q=-34.713575,-58.288414", type: "google"},
                 %{link: "https://www.alfajoresorense.com.ar/", type: "www"},
                 %{link: "https://www.instagram.com/orense.alfajores/", type: "instagram"},
                 %{
                   link:
                     "https://api.whatsapp.com/send?phone=+5491135665677&text=Consulta desde Comprar en Casa - Municipio de Quilmes",
                   type: "whatsapp"
                 }
               ],
               category_name: :category
             }
  end
end
