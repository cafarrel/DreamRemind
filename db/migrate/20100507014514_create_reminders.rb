class CreateReminders < ActiveRecord::Migration
  def self.up
    create_table :reminders do |t|      
      t.integer :category_id
      t.integer :user_id
      t.date :date
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :reminders
  end
end
