defmodule QCEC.Categories do
  @categories [
    {:bakery, 1},
    {:sushi, 2},
    {:processed_meals, 3},
    {:pet_food, 4},
    {:ice_creams, 5},
    {:warehouse_products, 7},
    {:cleaning_products, 8},
    {:fruits_and_vegetables, 9},
    {:meat_and_fish, 10},
    {:dietetics, 11},
    {:pizzas_and_empanadas, 12},
    {:spare_parts_for_vehicles, 15},
    {:hardware_stores, 16},
    {:clothes_washers, 17},
    {:pharmacies, 18},
    {:bookstore_items, 19},
    {:markets, 20},
    {:bookstores, 21},
    {:clothing_and_related, 22},
    {:footwear, 23},
    {:paint_shops, 24},
    {:leather_goods, 25},
    {:toy_stores, 26},
    {:drinks, 27},
    {:pasta, 28},
    {:without_tacc, 29},
    {:bazaar_and_decoration, 30},
    {:optics, 31}
  ]

  def list, do: @categories
end
