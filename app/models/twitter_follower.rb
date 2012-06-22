class TwitterFollower < ActiveRecord::Base
  belongs_to :influencer
  belongs_to :twitter_user

  attr_accessible :influencer_id, :influencer, :twitter_user_id, :twitter_user
end
