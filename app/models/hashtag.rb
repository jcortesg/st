class Hashtag < ActiveRecord::Base
  belongs_to :campaign

  attr_accessible :campaign, :campaign_id, :hashtag

  validates :hashtag, uniqueness: { scope: :campaign_id }, presence: true
end
