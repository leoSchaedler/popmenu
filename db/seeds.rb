# Clear existing data
MenuItem.destroy_all
Menu.destroy_all

# Create Menus
lunch = Menu.create!(name: "Lunch Menu", description: "Daytime specials")
dinner = Menu.create!(name: "Dinner Menu", description: "Evening meals")

# Create Menu Items
MenuItem.create!(name: "Burger", description: "Beef patty with lettuce and tomato", price: 9.99, menu: lunch)
MenuItem.create!(name: "Salad", description: "Mixed greens with vinaigrette", price: 5.99, menu: lunch)

MenuItem.create!(name: "Steak", description: "Grilled sirloin with mashed potatoes", price: 19.99, menu: dinner)
MenuItem.create!(name: "Pasta", description: "Spaghetti with marinara sauce", price: 12.99, menu: dinner)

puts "Seeded #{Menu.count} Menus and #{MenuItem.count} Menu items."