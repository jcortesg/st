class Tweet < ActiveRecord::Base
  belongs_to :campaign
  has_many :clicks

  attr_accessible :campaign_id, :text, :link_url, :fee_type
end
