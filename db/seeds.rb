# Clearing existing data
MenuItemization.destroy_all
MenuItem.destroy_all
Menu.destroy_all
Restaurant.destroy_all

# Creating Restaurants
pizzaPlace     = Restaurant.create!(name: "Pizza Joe's", description: "The best pizza in NYC")
burguerPlace   = Restaurant.create!(name: "Ram Buur Ger", description: "Simply the best burguer in the world")
brazilianPlace = Restaurant.create!(name: "Tropical Flavor", description: "Enjoy the world's best culinary")

# Creating Menus
pizzas     = Menu.create!(name: "Pizza Joe's Menu", description: "Pizza all day", restaurant: pizzaPlace)
burguers   = Menu.create!(name: "Ram Buur Ger Menu", description: "Burguers and Side Dishes", restaurant: burguerPlace)
brazilians = Menu.create!(name: "Tropical Flavor Menu", description: "Enjoy the variety of Brazilian Meals", restaurant: brazilianPlace)

# Creating Menu Items and Menu Itemizations (linking items to their respective menus)

# Pizza Joe's Items

margherita      = MenuItem.create!(name: "Margherita Pizza", description: "Classic pizza with tomato, mozzarella, and basil", price: 12.99, restaurant: pizzaPlace)
pepperoni       = MenuItem.create!(name: "Pepperoni Pizza", description: "Tomato, mozzarella, and spicy pepperoni", price: 14.49, restaurant: pizzaPlace)
four_cheese     = MenuItem.create!(name: "Four Cheese Pizza", description: "Mozzarella, gorgonzola, parmesan, and provolone", price: 15.99, restaurant: pizzaPlace)
bbq_chicken     = MenuItem.create!(name: "BBQ Chicken Pizza", description: "Grilled chicken, BBQ sauce, onions, mozzarella", price: 16.50, restaurant: pizzaPlace)
veggie_supreme  = MenuItem.create!(name: "Veggie Supreme", description: "Peppers, onions, mushrooms, olives, mozzarella", price: 13.99, restaurant: pizzaPlace)
hawaiian        = MenuItem.create!(name: "Hawaiian Pizza", description: "Ham, pineapple, mozzarella, tomato sauce", price: 14.99, restaurant: pizzaPlace)
meat_lovers     = MenuItem.create!(name: "Meat Lovers Pizza", description: "Pepperoni, sausage, ham, bacon, mozzarella", price: 17.99, restaurant: pizzaPlace)
white_pizza     = MenuItem.create!(name: "White Pizza", description: "Garlic, ricotta, spinach, mozzarella, olive oil", price: 13.49, restaurant: pizzaPlace)
buffalo_pizza   = MenuItem.create!(name: "Buffalo Pizza", description: "Buffalo chicken, mozzarella, ranch drizzle", price: 16.25, restaurant: pizzaPlace)
calzone_special = MenuItem.create!(name: "Calzone Special", description: "Folded pizza stuffed with meats and cheeses", price: 15.75, restaurant: pizzaPlace)

[margherita, pepperoni, four_cheese, bbq_chicken, veggie_supreme,
 hawaiian, meat_lovers, white_pizza, buffalo_pizza, calzone_special].each do |item|
  MenuItemization.create!(menu: pizzas, menu_item: item)
end

# Ram Buur Ger Items

classic_cheese  = MenuItem.create!(name: "Classic Cheeseburger", description: "Beef patty, cheddar cheese, lettuce, tomato", price: 10.99, restaurant: burguerPlace)
bacon_burger    = MenuItem.create!(name: "Bacon Burger", description: "Beef patty, crispy bacon, cheddar, BBQ sauce", price: 12.49, restaurant: burguerPlace)
mushroom_swiss  = MenuItem.create!(name: "Mushroom Swiss Burger", description: "Beef patty, sautéed mushrooms, swiss cheese", price: 11.99, restaurant: burguerPlace)
double_stack    = MenuItem.create!(name: "Double Stack Burger", description: "Two beef patties, cheese, pickles, onion", price: 14.50, restaurant: burguerPlace)
spicy_jalapeno  = MenuItem.create!(name: "Spicy Jalapeño Burger", description: "Beef patty, jalapeños, pepper jack, hot sauce", price: 12.99, restaurant: burguerPlace)
guacamole       = MenuItem.create!(name: "Guacamole Burger", description: "Beef patty, guac, lettuce, tomato, cheddar", price: 13.25, restaurant: burguerPlace)
fried_egg       = MenuItem.create!(name: "Fried Egg Burger", description: "Beef patty, fried egg, bacon, cheddar cheese", price: 13.75, restaurant: burguerPlace)
veggie_burger   = MenuItem.create!(name: "Veggie Burger", description: "Grilled veggie patty, lettuce, tomato, vegan mayo", price: 11.49, restaurant: burguerPlace)
pulled_pork     = MenuItem.create!(name: "BBQ Pulled Pork Burger", description: "Pulled pork, coleslaw, BBQ sauce, brioche bun", price: 14.25, restaurant: burguerPlace)
truffle_burger  = MenuItem.create!(name: "Truffle Burger", description: "Beef patty, truffle aioli, arugula, gruyere", price: 15.99, restaurant: burguerPlace)

[classic_cheese, bacon_burger, mushroom_swiss, double_stack, spicy_jalapeno,
 guacamole, fried_egg, veggie_burger, pulled_pork, truffle_burger].each do |item|
  MenuItemization.create!(menu: burguers, menu_item: item)
end

# Tropical Flavor Items

feijoada        = MenuItem.create!(name: "Feijoada", description: "Traditional black bean stew with pork and sausage", price: 18.99, restaurant: brazilianPlace)
pao_de_queijo   = MenuItem.create!(name: "Pão de Queijo", description: "Brazilian cheese bread made with cassava flour", price: 7.99, restaurant: brazilianPlace)
moqueca         = MenuItem.create!(name: "Moqueca", description: "Brazilian fish stew with coconut milk and palm oil", price: 21.50, restaurant: brazilianPlace)
coxinha         = MenuItem.create!(name: "Coxinha", description: "Chicken croquettes with creamy filling", price: 8.99, restaurant: brazilianPlace)
picanha         = MenuItem.create!(name: "Picanha", description: "Grilled sirloin cap steak, served with farofa", price: 25.99, restaurant: brazilianPlace)
brigadeiro      = MenuItem.create!(name: "Brigadeiro", description: "Chocolate fudge truffles rolled in sprinkles", price: 6.50, restaurant: brazilianPlace)
acaraje         = MenuItem.create!(name: "Acarajé", description: "Fried black-eyed pea fritters with shrimp filling", price: 15.75, restaurant: brazilianPlace)
vatapa          = MenuItem.create!(name: "Vatapá", description: "Creamy shrimp stew with coconut milk and peanuts", price: 17.25, restaurant: brazilianPlace)
farofa          = MenuItem.create!(name: "Farofa", description: "Toasted cassava flour with bacon and onions", price: 9.50, restaurant: brazilianPlace)
caipirinha_sorb = MenuItem.create!(name: "Caipirinha Sorbet", description: "Frozen lime dessert with cachaça flavor", price: 8.25, restaurant: brazilianPlace)

[feijoada, pao_de_queijo, moqueca, coxinha, picanha,
 brigadeiro, acaraje, vatapa, farofa, caipirinha_sorb].each do |item|
  MenuItemization.create!(menu: brazilians, menu_item: item)
end


puts "Seeded #{Restaurant.count} Restaurants, alongside #{Menu.count} Menus and #{MenuItem.count} Menu items in total."