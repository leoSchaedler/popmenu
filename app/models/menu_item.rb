class MenuItem < ApplicationRecord
  belongs_to :restaurant

  # Opted to use delete_all to avoid possible callback that could affect Menus
  has_many :menu_itemizations, dependent: :delete_all

  validates :name, :description, :price, presence: true
  validates :name, uniqueness: true # Enforcing unique names for MenuItems
end
