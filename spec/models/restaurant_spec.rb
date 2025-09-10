require 'rails_helper'

# Unit specs for Restaurant
RSpec.describe Restaurant, type: :model do
  subject { build(:restaurant) }

  # Creation
  it 'can be created successfully' do
    expect { create(:restaurant) }.to change(Restaurant, :count).by(1)
  end

  # Associations
  it { should have_many(:menus).dependent(:destroy) }
  it { should have_many(:menu_items).dependent(:destroy) }

  # Validations
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
end
