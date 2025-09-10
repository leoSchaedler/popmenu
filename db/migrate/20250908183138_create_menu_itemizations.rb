class CreateMenuItemizations < ActiveRecord::Migration[8.0]
  def up
    create_table :menu_itemizations do |t|
      t.references :menu, null: false, foreign_key: true
      t.references :menu_item, null: false, foreign_key: true
      t.timestamps
    end
  end

  def down
    drop_table :menu_itemizations
  end
end
