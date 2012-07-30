class AddLastStatsSyncToTwitterUsers < ActiveRecord::Migration
  def change
    add_column :twitter_users, :last_sync_at, :datetime
    add_index :twitter_users, :last_sync_at
  end
end
