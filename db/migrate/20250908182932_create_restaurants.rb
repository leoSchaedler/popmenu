class CreateRestaurants < ActiveRecord::Migration[8.0]
  def up
    create_table :restaurants do |t|
      t.string :name
      t.text :description
      t.timestamps
    end
  end

  def down
    drop_table :restaurants
  end
end
