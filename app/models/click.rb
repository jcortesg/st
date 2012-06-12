class Click < ActiveRecord::Base
  belongs_to :tweet

  attr_accessible :tweet, :tweet_id, :remote_ip, :remote_agent
end
