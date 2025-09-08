json.array! @menu_items do |item|
  json.extract! item, :id, :name, :description, :price
  json.menu_id item.menu_id
end
