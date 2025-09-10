class Menu < ApplicationRecord
  belongs_to :restaurant

  # Opted to use delete_all to avoid possible callback that could affect MenuItems
  has_many :menu_itemizations, dependent: :delete_all
  has_many :menu_items, through: :menu_itemizations

  validates :name, :description, presence: true
end
