class Campaign < ActiveRecord::Base
  belongs_to :advertiser
  has_many :tweets, dependent: :destroy
  has_many :clicks, through: :tweets, dependent: :destroy

  serialize :locations, Array

  attr_accessible :name, :min_followers, :max_followers, :min_males, :max_males, :min_females, :max_females,
                  :min_kids, :max_kids, :min_adults, :max_adults, :min_elderly, :max_elderly,
                  :min_young_teens, :max_young_teens, :min_mature_teens, :max_mature_teens,
                  :min_young_adults, :max_young_adults, :min_mature_adults, :max_mature_adults,
                  :min_sports, :max_sports, :min_fashion, :max_fashion, :min_music, :max_music,
                  :min_movies, :max_movies, :min_politics, :max_politics

  validates :name, uniqueness: { scope: :advertiser_id }
  validates :objectives, presence: true

  validates :followers_quantity, presence: true, on: [:update]

  class << self
    # Brings the archived campaigns
    def archived
      where(archived: true)
    end

    # Brings the active campaigns
    def active
      where(archived: false)
    end
  end

end
