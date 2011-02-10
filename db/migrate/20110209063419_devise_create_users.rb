class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.string :first_name
      t.string :last_name
      t.string :login,:null=>false
      t.boolean :active,:default=>true
      t.string :zip
      t.references :state
      t.references :country
      t.integer :roles_mask
      t.database_authenticatable :null => false
      t.confirmable
      t.recoverable
      t.rememberable
      t.trackable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both

      t.timestamps
    end

    add_index :users, :email,                :unique => true
    add_index :users, :confirmation_token,   :unique => true
    add_index :users, :reset_password_token, :unique => true
    # add_index :users, :unlock_token,         :unique => true
    @user = User.create!(:first_name=>'Admin',:last_name=>'Admin',:login=>'admin',:email=>'admin@test.com',:password=>'12345678',:password_confirmation=>'12345678',:zip=>'123456',:roles=>[User::ROLES[0]])
  @user.update_attribute(:roles,([User::ROLES[0]]))

  end

  def self.down
    drop_table :users
  end
end

