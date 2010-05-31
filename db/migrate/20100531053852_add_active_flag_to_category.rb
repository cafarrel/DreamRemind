class AddActiveFlagToCategory < ActiveRecord::Migration
  def self.up
    add_column :categories, :active, :boolean
  end

  def self.down
    remove_column :categories, :active
  end
end
