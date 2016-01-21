class CreateCategoriesItems < ActiveRecord::Migration
  def change
    create_table :categories_items, :id => false do |t|
      t.references :category
      t.references :item
    end

    add_index :categories_items, [:category_id, :item_id],
      name: "categories_items_index",
      unique: true
  end
end
