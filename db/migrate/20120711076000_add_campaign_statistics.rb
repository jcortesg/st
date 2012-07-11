class AddCampaignStatistics < ActiveRecord::Migration
  def up
    add_column :campaigns, :status, :string, after: 'objective'
    add_column :campaigns, :starts_at, :datetime, after: 'status'
    add_column :campaigns, :ends_at, :datetime, after: 'starts_at'

    add_column :campaigns, :twitter_screen_name, :string, after: 'objective'

    add_column :campaigns, :retweets_count, :integer, after: 'clicks_count', null: false, default: 0
    add_column :campaigns, :mentions_count, :integer, after: 'retweets_count', null: false, default: 0
    add_column :campaigns, :hashtag_count, :integer, after: 'mentions_count', null: false, default: 0
    add_column :campaigns, :followers_start_count, :integer, after: 'hashtag_count'
    add_column :campaigns, :followers_end_count, :integer, after: 'followers_start_count'
    add_column :campaigns, :reach, :integer, after: 'followers_end_count', null: false, default: 0
    add_column :campaigns, :share, :integer, after: 'reach', null: false, default: 0

    remove_column :campaigns, :archived
  end

  def down
    remove_column :campaigns, :status
    remove_column :campaigns, :starts_at
    remove_column :campaigns, :ends_at

    remove_column :campaigns, :twitter_screen_name

    remove_column :campaigns, :retweets_count
    remove_column :campaigns, :mentions_count
    remove_column :campaigns, :hashtag_count
    remove_column :campaigns, :followers_start_count
    remove_column :campaigns, :followers_end_count
    remove_column :campaigns, :reach
    remove_column :campaigns, :share

    add_column :campaigns, :archived, :boolean, null: false, default: false, after: 'objective'
  end
end
