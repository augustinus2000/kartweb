class CreateCartItems < ActiveRecord::Migration[8.0]
  def change
    create_table :cart_items do |t|
      t.string :name
      t.integer :price
      t.integer :quantity

      t.timestamps
    end
  end
end
