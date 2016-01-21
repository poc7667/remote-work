class CreateItemsUsers < ActiveRecord::Migration
  def change
    create_table :items_users, :id => false do |t|
      t.references :item
      t.references :user
    end

    add_index :items_users, [:item_id, :user_id],
      name: "items_users_index",
      unique: true
  end
end
