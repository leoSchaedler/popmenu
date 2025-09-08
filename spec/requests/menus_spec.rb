require 'rails_helper'

RSpec.describe "Menus API", type: :request do
  let!(:menus) { create_list(:menu, 3) }
  let(:menu_id) { menus.first.id }
  let(:json_headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /menus' do
    it 'returns all menus' do
      get '/menus', headers: json_headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe 'GET /menus/:id' do
    it 'returns the menu' do
      get "/menus/#{menu_id}", headers: json_headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['id']).to eq(menu_id)
    end
  end

  describe 'POST /menus' do
    let(:valid_attributes) { { menu: { name: "Test Menu", description: "Test Desc" } } }

    it 'creates a menu' do
      expect {
        post '/menus', params: valid_attributes, headers: json_headers
      }.to change(Menu, :count).by(1)

      expect(response).to have_http_status(:created)
    end
  end

  describe 'PUT /menus/:id' do
    let(:update_attributes) { { menu: { name: 'Updated Name' } } }

    it 'updates the menu' do
      put "/menus/#{menu_id}", params: update_attributes, headers: json_headers
      expect(response).to have_http_status(:ok)
      expect(Menu.find(menu_id).name).to eq('Updated Name')
    end
  end

  describe 'DELETE /menus/:id' do
    it 'deletes the menu' do
      expect {
        delete "/menus/#{menu_id}", headers: json_headers
      }.to change(Menu, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
