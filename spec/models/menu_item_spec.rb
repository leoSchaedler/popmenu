require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  subject { build(:menu_item) } # Ensures an associated menu exists

  describe 'associations' do
    it { should belong_to(:menu) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:price) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:menu_item)).to be_valid
    end

    it 'generates a menu_item with a menu' do
      menu_item = create(:menu_item)
      expect(menu_item.menu).to be_present
    end
  end
end
