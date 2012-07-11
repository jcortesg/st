class Hashtag < ActiveRecord::Base
  belongs_to :campaign

  validates :hashtag, uniqueness: { scope: :campaign_id }, presence: true
end
