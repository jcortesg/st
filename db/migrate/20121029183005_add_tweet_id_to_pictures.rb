class AddTweetIdToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :tweet_id, :integer
  end
end
