class MenuItemization < ApplicationRecord
  # This Class' table works as an Association table in order to join Menu and MenuItems,
  # allowing MenuItems of one restaurant to be in different Menus of the same Restaurant.
  belongs_to :menu
  belongs_to :menu_item

  validates :menu_id, :menu_item_id, presence: true
end
