class CreateCurrentCarts < ActiveRecord::Migration[8.0]
  def change
    create_table :current_carts do |t|
      t.string :cart_uuid

      t.timestamps
    end
  end
end
