require 'rails_helper'

RSpec.describe "MenuItems API", type: :request do
  let!(:restaurant) { create(:restaurant) }
  let!(:menu) { create(:menu, restaurant: restaurant) }
  let!(:menu_items) do
    items = create_list(:menu_item, 3, restaurant: restaurant)
    items.each { |item| MenuItemization.create!(menu: menu, menu_item: item) }
    items
  end
  let(:menu_item_id) { menu_items.first.id }

  describe 'GET /api/restaurants/:restaurant_id/menus/:menu_id/menu_items' do
    it 'returns all menu items for a menu in correct JSON structure' do
      get "/api/restaurants/#{restaurant.id}/menus/#{menu.id}/menu_items",
          headers: { "ACCEPT" => "application/json" }
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json.size).to eq(3)

      json.each do |item_json|
        # Check menu_item attributes
        expect(item_json.keys).to contain_exactly("id", "name", "description", "price", "restaurant_id")
        expect(item_json["restaurant_id"]).to eq(restaurant.id)
      end
    end
  end

  describe 'GET /api/restaurants/:restaurant_id/menus/:menu_id/menu_items/:id' do
    it 'returns a single menu item in correct JSON structure' do
      get "/api/restaurants/#{restaurant.id}/menus/#{menu.id}/menu_items/#{menu_item_id}",
          headers: { "ACCEPT" => "application/json" }
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      # Check menu_item attributes
      expect(json.keys).to contain_exactly("id", "name", "description", "price", "restaurant_id")
      expect(json["id"]).to eq(menu_item_id)
      expect(json["restaurant_id"]).to eq(restaurant.id)
    end
  end


  describe 'POST /api/restaurants/:restaurant_id/menus/:menu_id/menu_items' do
    let(:valid_attributes) do
      { menu_item: { name: 'New Dish', description: 'Tasty', price: '19.99' } }
    end

    it 'creates a menu item and links it to the menu via MenuItemization' do
      expect {
        post "/api/restaurants/#{restaurant.id}/menus/#{menu.id}/menu_items", params: valid_attributes
      }.to change(MenuItem, :count).by(1)
       .and change(MenuItemization, :count).by(1)

      menu_item = MenuItem.last
      expect(menu_item.restaurant).to eq(restaurant)
      expect(menu.menu_items).to include(menu_item)
    end
  end

  describe 'PUT /api/restaurants/:restaurant_id/menus/:menu_id/menu_items/:id' do
    let(:update_attributes) { { menu_item: { price: '29.99' } } }

    it 'updates the menu item' do
      put "/api/restaurants/#{restaurant.id}/menus/#{menu.id}/menu_items/#{menu_item_id}", params: update_attributes
      expect(response).to have_http_status(:ok)
      expect(MenuItem.find(menu_item_id).price.to_s).to eq('29.99')
    end
  end

  describe 'DELETE /api/restaurants/:restaurant_id/menus/:menu_id/menu_items/:id' do
    it 'deletes the menu item and its MenuItemization' do
      expect {
        delete "/api/restaurants/#{restaurant.id}/menus/#{menu.id}/menu_items/#{menu_item_id}"
      }.to change(MenuItem, :count).by(-1)
       .and change(MenuItemization, :count).by(-1*menu_items.first.menu_itemizations.count)

      expect(response).to have_http_status(:no_content)
    end
  end
end
