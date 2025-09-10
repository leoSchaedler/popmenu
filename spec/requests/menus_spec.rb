require 'rails_helper'

RSpec.describe "API::Menus", type: :request do
  let!(:restaurant) { create(:restaurant) }
  let!(:menus) { create_list(:menu, 3, restaurant: restaurant) }
  let(:menu_id) { menus.first.id }

  describe 'GET /api/restaurants/:restaurant_id/menus' do
    it 'returns all menus with their menu items in correct JSON structure' do
      get "/api/restaurants/#{restaurant.id}/menus",
          headers: { "ACCEPT" => "application/json" }
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json.size).to eq(3)

      json.each do |menu_json|
        # Check menu attributes
        expect(menu_json.keys).to contain_exactly("id", "name", "description", "menu_items")
        # Check menu_items array
        menu_json["menu_items"].each do |item_json|
          expect(item_json.keys).to contain_exactly("id", "name", "description", "price")
        end
      end
    end
  end

  describe 'GET /api/restaurants/:restaurant_id/menus/:id' do
    it 'returns a single menu with its menu items in correct JSON structure' do
      get "/api/restaurants/#{restaurant.id}/menus/#{menu_id}",
          headers: { "ACCEPT" => "application/json" }
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      # Check menu attributes
      expect(json.keys).to contain_exactly("id", "name", "description", "menu_items")
      expect(json["id"]).to eq(menu_id)
      # Check menu_items array
      json["menu_items"].each do |item_json|
        expect(item_json.keys).to contain_exactly("id", "name", "description", "price")
      end
    end
  end

  describe 'POST /api/restaurants/:restaurant_id/menus' do
    let(:valid_attributes) { { menu: { name: 'Lunch Menu', description: 'Daily specials' } } }

    it 'creates a menu for a restaurant' do
      expect {
        post "/api/restaurants/#{restaurant.id}/menus", params: valid_attributes
      }.to change(Menu, :count).by(1)
      expect(response).to have_http_status(:created)
    end
  end

  describe 'PUT /api/restaurants/:restaurant_id/menus/:id' do
    let(:update_attributes) { { menu: { name: 'Updated Menu' } } }

    it 'updates a menu' do
      put "/api/restaurants/#{restaurant.id}/menus/#{menu_id}", params: update_attributes
      expect(response).to have_http_status(:ok)
      expect(Menu.find(menu_id).name).to eq('Updated Menu')
    end
  end

  describe 'DELETE /api/restaurants/:restaurant_id/menus/:id' do
    it 'deletes a menu' do
      expect {
        delete "/api/restaurants/#{restaurant.id}/menus/#{menu_id}"
      }.to change(Menu, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
