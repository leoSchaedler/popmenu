class AddUniqueMenuItemizationIndex < ActiveRecord::Migration[8.0]
    def up
      add_index :menu_itemizations, [ :menu_id, :menu_item_id ], unique: true
    end

  def down
    remove_index :menu_itemizations, [ :menu_id, :menu_item_id ]
  end
end
