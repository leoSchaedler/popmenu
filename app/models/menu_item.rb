class MenuItem < ApplicationRecord
  belongs_to :restaurant
  
  has_many :menu_itemizations

  validates :name, :description, :price, presence: true
end
