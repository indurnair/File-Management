class CreateUserFiles < ActiveRecord::Migration
  def self.up
    create_table :user_files do |t|
      t.string :attachment_file_name
      t.string :attachment_content_type
      t.integer :attachment_file_size
      t.references :user
      t.integer :parent_id
      t.string :ancestors
      t.boolean :published,:default =>false
      t.string :title
      t.text :description
      t.string :version_number
      t.timestamps
    end
  end

  def self.down
    drop_table :user_files
  end
end

