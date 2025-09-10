require 'rails_helper'

RSpec.describe "API::Restaurants", type: :request do
  let!(:restaurants) { create_list(:restaurant, 3) }
  let(:restaurant_id) { restaurants.first.id }

  describe 'GET /api/restaurants' do
    it 'returns all restaurants with menus and menu_items in correct JSON structure' do
      get '/api/restaurants',
          headers: { "ACCEPT" => "application/json" }
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json.size).to eq(3)

      json.each do |restaurant_json|
        # Check restaurant attributes
        expect(restaurant_json.keys).to include("id", "name", "description", "menus")
        # Check menus
        restaurant_json["menus"].each do |menu_json|
          expect(menu_json.keys).to include("id", "name", "description", "menu_items")
          # Check menu_items
          menu_json["menu_items"].each do |item_json|
            expect(item_json.keys).to contain_exactly("id", "name", "description", "price")
          end
        end
      end
    end
  end

  describe 'GET /api/restaurants/:id' do
    it 'returns a single restaurant with menus and menu_items in correct JSON structure' do
      get "/api/restaurants/#{restaurant_id}",
          headers: { "ACCEPT" => "application/json" }
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      # Check restaurant attributes
      expect(json.keys).to include("id", "name", "description", "menus")
      expect(json["id"]).to eq(restaurant_id)
      # Check menus
      json["menus"].each do |menu_json|
        expect(menu_json.keys).to include("id", "name", "description", "menu_items")
        # Check menu_items
        menu_json["menu_items"].each do |item_json|
          expect(item_json.keys).to contain_exactly("id", "name", "description", "price")
        end
      end
    end
  end


  describe 'POST /api/restaurants' do
    let(:valid_attributes) { { restaurant: { name: 'New Rest', description: 'Tasty place' } } }

    it 'creates a restaurant' do
      expect {
        post '/api/restaurants', params: valid_attributes
      }.to change(Restaurant, :count).by(1)
      expect(response).to have_http_status(:created)
    end
  end

  describe 'PUT /api/restaurants/:id' do
    let(:update_attributes) { { restaurant: { name: 'Updated Name' } } }

    it 'updates a restaurant' do
      put "/api/restaurants/#{restaurant_id}", params: update_attributes
      expect(response).to have_http_status(:ok)
      expect(Restaurant.find(restaurant_id).name).to eq('Updated Name')
    end
  end

  describe 'DELETE /api/restaurants/:id' do
    it 'deletes a restaurant' do
      expect {
        delete "/api/restaurants/#{restaurant_id}"
      }.to change(Restaurant, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
