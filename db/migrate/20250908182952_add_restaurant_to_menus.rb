class AddRestaurantToMenus < ActiveRecord::Migration[8.0]
  def up
    add_reference :menus, :restaurant, null: false, foreign_key: true
  end

  def down
    remove_reference :menus, :restaurant, foreign_key: true
  end
end
