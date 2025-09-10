class MenuItemization < ApplicationRecord
  belongs_to :menu
  belongs_to :menu_item

  validates :menu_id, :menu_item_id, presence: true
end
