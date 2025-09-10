json.array! @menu_items do |item|
  json.extract! item, :id, :name, :description, :price
  json.restaurant_id item.restaurant_id
end
