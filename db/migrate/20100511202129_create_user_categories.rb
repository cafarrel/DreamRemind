class CreateUserCategories < ActiveRecord::Migration
  def self.up
    create_table :user_categories, :id => false do |t|
      t.integer :category_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :user_categories
  end
end