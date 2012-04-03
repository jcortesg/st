class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.database_authenticatable :null => false
      t.string :user_type, :null => false
      t.boolean :approved, :null => false, :default => false
      t.recoverable
      t.rememberable
      t.trackable  
      t.confirmable    
      t.timestamps
    end

    add_index :users, :email,                :unique => true
    add_index :users, :user_type,            :unique => false
    add_index :users, :reset_password_token, :unique => true
  end
end