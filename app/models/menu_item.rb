class MenuItem < ApplicationRecord
  belongs_to :restaurant

  has_many :menu_itemizations, dependent: :delete_all

  validates :name, :description, :price, presence: true
  validates :name, uniqueness: true
end
