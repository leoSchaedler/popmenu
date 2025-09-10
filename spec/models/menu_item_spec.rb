require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  let(:restaurant) { create(:restaurant) }
  let(:menu) { create(:menu, restaurant: restaurant) }

  subject { build(:menu_item, restaurant: restaurant) }

  # Creation
  it 'can be created successfully' do
    expect { create(:menu_item) }.to change(MenuItem, :count).by(1)
  end

  # Associations
  it { should belong_to(:restaurant) }
  it { should have_many(:menu_itemizations).dependent(:delete_all) }

  # Validations
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:price) }

  # Callback behavior
  describe 'after create' do
    it 'creates a menu_itemization for the menu it belongs to' do
      item = create(:menu_item, restaurant: restaurant)
      menu_itemization = create(:menu_itemization, menu: menu, menu_item: item)
      expect(item.menu_itemizations.exists?(menu: menu)).to be_truthy
    end
  end
end
