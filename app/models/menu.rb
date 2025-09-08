class Menu < ApplicationRecord
  belongs_to :restaurant
  
  has_many :menu_itemizations
  has_many :menu_items, through: :menu_itemizations

  validates :name, :description, presence: true
end
