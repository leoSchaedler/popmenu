class Menu < ApplicationRecord
  has_many :menu_items, dependent: :destroy

  validates :name, :description, presence: true
end
