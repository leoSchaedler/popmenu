class AddRestaurantToMenuItems < ActiveRecord::Migration[8.0]
    def up
    add_reference :menu_items, :restaurant, null: false, foreign_key: true
  end

  def down
    remove_reference :menu_items, :restaurant, foreign_key: true
  end
end
