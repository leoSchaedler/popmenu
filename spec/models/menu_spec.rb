require 'rails_helper'

RSpec.describe Menu, type: :model do
  describe 'associations' do
    it { should have_many(:menu_items).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:menu)).to be_valid
    end

    it 'can create a menu without menu_items' do
      menu = create(:menu) # creates without menu_items by default
      expect(menu.menu_items.count).to eq(0)
    end

    it 'allows specifying a custom number of items' do
      menu = create(:menu, items_count: 5)
      expect(menu.menu_items.count).to eq(5)
      expect(menu.menu_items.first).to be_valid
    end
  end
end
