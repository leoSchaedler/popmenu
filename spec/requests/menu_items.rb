require 'rails_helper'

RSpec.describe "MenuItems API", type: :request do
  let!(:menu) { create(:menu) }
  let!(:menu_items) { create_list(:menu_item, 3, menu: menu) }
  let(:menu_item_id) { menu_items.first.id }

  describe 'GET /api/menus/:menu_id/menu_items' do
    it 'returns all menu items for a menu' do
      get "/api/menus/#{menu.id}/menu_items"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe 'GET /api/menus/:menu_id/menu_items/:id' do
    it 'returns a single menu item' do
      get "/api/menus/#{menu.id}/menu_items/#{menu_item_id}"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['id']).to eq(menu_item_id)
    end
  end

  describe 'POST /api/menus/:menu_id/menu_items' do
    let(:valid_attributes) { { menu_item: { name: 'New Dish', description: 'Tasty', price: '19.99' } } }

    it 'creates a menu item' do
      expect {
        post "/api/menus/#{menu.id}/menu_items", params: valid_attributes
      }.to change(MenuItem, :count).by(1)

      expect(response).to have_http_status(:created)
    end
  end

  describe 'PUT /api/menus/:menu_id/menu_items/:id' do
    let(:update_attributes) { { menu_item: { price: '29.99' } } }

    it 'updates the menu item' do
      put "/api/menus/#{menu.id}/menu_items/#{menu_item_id}", params: update_attributes
      expect(response).to have_http_status(:ok)
      expect(MenuItem.find(menu_item_id).price.to_s).to eq('29.99')
    end
  end

  describe 'DELETE /api/menus/:menu_id/menu_items/:id' do
    it 'deletes the menu item' do
      expect {
        delete "/api/menus/#{menu.id}/menu_items/#{menu_item_id}"
      }.to change(MenuItem, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
