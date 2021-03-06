class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      # Database authenticatable
      t.string :email,              :null => false, :default => ""
      t.string :encrypted_password, :null => false, :default => ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      # Twitter credentials
      t.boolean :twitter_linked, :null => false, :default => false
      t.string :twitter_screen_name
      t.string :twitter_uid
      t.string :twitter_token
      t.string :twitter_secret

      t.string :role, :null => false
      t.boolean :approved, :null => false, :default => false

      t.timestamps
    end

    add_index :users, :email,                :unique => true
    add_index :users, :role,                 :unique => false
    add_index :users, :reset_password_token, :unique => true
    add_index :users, :approved,             :unique => false
    add_index :users, :twitter_screen_name, :unique => true
  end
end