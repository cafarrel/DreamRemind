class AddActiveFlagToUserCategory < ActiveRecord::Migration
  def self.up
    add_column :user_categories, :active, :boolean
  end

  def self.down
    remove_column :user_categories, :active
  end
end
