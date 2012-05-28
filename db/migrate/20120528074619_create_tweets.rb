class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.references :campaign

      t.string :text

      t.string :link_code
      t.string :link_url

      t.string :fee_type
      t.decimal :tweet_fee, precision: 8, scale: 2, null: false, default: 0
      t.decimal :cpc, precision: 8, scale: 2, null: false, default: 0

      t.integer :clicks_count, null: false, default: 0

      t.timestamps
    end

    add_index :tweets, :campaign_id, unique: false
    add_index :tweets, :link_code, unique: true
  end
end
