class CreateMenuItems < ActiveRecord::Migration[8.0]
  def up
    create_table :menu_items do |t|
      t.string :name
      t.text :description
      t.decimal :price, precision: 10, scale: 2, null: false
      t.references :menu, null: false, foreign_key: true
      t.timestamps
    end
  end

  def down
    drop_table :menu_items
  end
end
