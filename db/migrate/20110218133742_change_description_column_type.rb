class ChangeDescriptionColumnType < ActiveRecord::Migration
  def self.up
    change_column :user_files,:description,:text
  end

  def self.down
    change_column :user_files,:description,:string
  end
end

