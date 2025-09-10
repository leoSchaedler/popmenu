class AddUniqueMenuItemNameIndex < ActiveRecord::Migration[8.0]
  def up
    add_index :menu_items, :name, unique: true
  end

  def down
    remove_index :menu_items, :name
  end
end
