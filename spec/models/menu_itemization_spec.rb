require 'rails_helper'

# Unit specs for MenuItemization
RSpec.describe MenuItemization, type: :model do
  let(:restaurant) { create(:restaurant) }
  let(:menu) { create(:menu, restaurant: restaurant) }
  let(:menu_item) { create(:menu_item, restaurant: restaurant) }

  subject { build(:menu_itemization, menu: menu, menu_item: menu_item) }

  # Creation
  it 'can be created successfully' do
    expect { create(:menu_itemization) }.to change(MenuItemization, :count).by(1)
  end

  # Associations
  it { should belong_to(:menu) }
  it { should belong_to(:menu_item) }

  # Validations
  it { should validate_presence_of(:menu_id) }
  it { should validate_presence_of(:menu_item_id) }
end
