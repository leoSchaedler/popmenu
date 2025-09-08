class MenuItem < ApplicationRecord
  belongs_to :menu

  validates :name, :description, :price, presence: true
end
