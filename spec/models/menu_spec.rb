require 'rails_helper'

# Unit specs for Menu
RSpec.describe Menu, type: :model do
  let(:restaurant) { create(:restaurant) }

  subject { build(:menu, restaurant: restaurant) }

  # Creation
  it 'can be created successfully' do
    expect { create(:menu) }.to change(Menu, :count).by(1)
  end

  # Associations
  it { should belong_to(:restaurant) }
  it { should have_many(:menu_itemizations).dependent(:delete_all) }
  it { should have_many(:menu_items).through(:menu_itemizations) }

  # Validations
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }

  # Callback behavior
  describe 'after create' do
    it 'creates a menu_itemization for each associated menu_item' do
      menu = create(:menu, restaurant: restaurant)
      item = create(:menu_item, restaurant: restaurant)
      menu_itemization = create(:menu_itemization, menu: menu, menu_item: item)
      expect(menu.menu_itemizations.exists?(menu_item: item)).to be_truthy
    end
  end
end
