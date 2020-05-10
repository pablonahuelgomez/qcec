alias QCEC.Category

defmodule QCECTest.Category do
  use ExUnit.Case, async: true

  test "from_document parses the category" do
    {:ok, file} = File.read('test/category.html')
    {:ok, document} = Floki.parse_document(file)

    assert Category.from_document(document) ==
             %Category{
               name: "Ópticas",
               image_url: "https://quilmes.gov.ar/servicios/rubros/opticas.png"
             }
  end

  test "from_document parses the category 2" do
    {:ok, file} = File.read('test/category2.html')
    {:ok, document} = Floki.parse_document(file)

    assert Category.from_document(document) ==
             %Category{
               name: "Panadería",
               image_url: "https://quilmes.gov.ar/servicios/rubros/panaderia.png"
             }
  end
end
