class RemoveMenuFromMenuItems < ActiveRecord::Migration[8.0]
    def up
    remove_reference :menu_items, :menu, foreign_key: true
  end

  def down
    add_reference :menu_items, :menu, foreign_key: true
  end
end
