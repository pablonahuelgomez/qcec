defmodule QCEC.Categories do
  @categories [
    {:bakery, 1, "panadería"},
    {:sushi, 2, "sushi"},
    {:processed_meals, 3, "comidas"},
    {:pet_food, 4, "alimentos para mascotas"},
    {:ice_creams, 5, "heladerías"},
    {:warehouse_products, 7, "productos de almacen"},
    {:cleaning_products, 8, "productos de limpieza"},
    {:fruits_and_vegetables, 9, "frutas y verduras"},
    {:meat_and_fish, 10, "carnes y pescados"},
    {:dietetics, 11, "dietéticas"},
    {:pizzas_and_empanadas, 12, "pizzas & empanadas"},
    {:spare_parts_for_vehicles, 15, "repuestos para vehículos"},
    {:hardware_stores, 16, "ferreterías"},
    {:clothes_washers, 17, "lavaderos de ropa"},
    {:pharmacies, 18, "farmacias"},
    {:bookstore_items, 19, "artículos de librería"},
    {:markets, 20, "mercados"},
    {:bookstores, 21, "librerías"},
    {:clothing_and_related, 22, "indumentaria"},
    {:footwear, 23, "calzado"},
    {:paint_shops, 24, "pinturerías"},
    {:leather_goods, 25, "marroquinerías"},
    {:toy_stores, 26, "jugueterías"},
    {:drinks, 27, "bebidas"},
    {:pasta, 28, "pastas"},
    {:without_tacc, 29, "sin tacc"},
    {:bazaar_and_decoration, 30, "decoración y bazaar"},
    {:optics, 31, "óptica"},
    {:baby_children_clothing, 32, "indumentaria bebes / niños"},
    {:sports, 33, "artículos deportivos"},
    {:cellphones_informatics, 34, "celulares / informática"},
    {:blankets, 35, "blanquería"},
    {:lingerie, 36, "lencería"},
    {:merceries, 37, "mercerías"},
    {:music, 38, "música"},
    {:cotillon, 39, "cotillón"},
    {:electrodomestics, 40, "electrodomésticos"},
    {:jewelry, 41, "joyas / relojes"},
    {:furniture, 42, "mueblerías"},
    {:perfumery, 43, "perfumería"},
    {:luminary, 44, "iluminación"},
    {:plants, 45, "viveros"},
    {:personal_hygiene, 46, "higiene personal"},
    {:craft, 47, "artesanías / economía social"},
    {:hair_products, 48, "insumos peluquerías"}
  ]

  def list(:all), do: @categories
  def list(:names), do: @categories |> Enum.map(fn {name, _, _} -> name end)

  def id(category_name) do
    {_, id, _} =
      Enum.find(@categories, fn {name, _, _} ->
        name == category_name
      end)

    id
  end
end
