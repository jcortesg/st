class AddRejectCauseToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :reject_cause, :text
  end
end
