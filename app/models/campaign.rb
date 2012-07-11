# encoding: utf-8
class Campaign < ActiveRecord::Base
  belongs_to :advertiser
  has_many :tweets, dependent: :destroy
  has_many :hashtags, dependent: :destroy
  has_many :clicks, through: :tweets, dependent: :destroy
  has_many :campaign_metrics, dependent: :destroy

  serialize :locations, Array
  serialize :followers_qty, Array
  serialize :tweet_price, Array

  attr_accessible :name, :objective, :twitter_screen_name, :locations, :males, :females, :moms, :teens,
                  :college_students, :young_women, :young_men, :adult_women, :adult_men, :sports, :fashion, :music,
                  :movies, :politics, :technology, :travel, :luxury, :followers_qty, :tweet_price, :price_per_click

  validates :name, uniqueness: { scope: :advertiser_id }, presence: true
  validates :objective, presence: true
  validate :twitter_screen_name_validation

  validates :followers_qty, presence: true, on: :update

  # Tweet status:
  # * created: Campaign created
  # * active: Campaign has been started
  # * archived: Campaign has finished

  state_machine :status, initial: :created do

    event :activate_campaign do
      transition [:created] => [:active]
    end

    event :archive_campaign do
      transition [:active] => [:archived]
    end
  end

  class << self
    # Brings the created and active campaign
    def created_and_active
      where("status = 'created' or status = 'active'")
    end

    # Brings the created campaigns
    def created
      where(status: 'created')
    end

    # Brings the archived campaigns
    def archived
      where(status: 'archived')
    end

    # Brings the active campaigns
    def active
      where(statuc: 'active')
    end
  end

  private

  # Check the twitter screen name
  def twitter_screen_name_validation
    unless twitter_screen_name.blank?
      begin
        if twitter_screen_name.match(/^@[a-zA-Z0-9]+/)
          t = Twitter.user(twitter_screen_name)
        else
          errors.add(:twitter_screen_name, 'El usuario de Twitter no es válido')
        end
      rescue Exception => e
        errors.add(:twitter_screen_name, 'El usuario de Twitter no existe')
      end
    end
  end

end
