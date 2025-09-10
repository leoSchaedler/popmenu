json.extract! @menu, :id, :name, :description
json.menu_items @menu.menu_items do |item|
  json.extract! item, :id, :name, :description, :price
end
