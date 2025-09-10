class Restaurant < ApplicationRecord
  has_many :menus, dependent: :destroy
  has_many :menu_items, dependent: :destroy

  validates :name, :description, presence: true
end
