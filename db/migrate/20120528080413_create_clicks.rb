class CreateClicks < ActiveRecord::Migration
  def change
    create_table :clicks do |t|
      t.references :tweet

      t.string :remote_ip
      t.string :remote_agent

      t.timestamps
    end

    add_index :clicks, :tweet_id, unique: false
  end
end
