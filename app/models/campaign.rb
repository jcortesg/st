# encoding: utf-8
class Campaign < ActiveRecord::Base
  belongs_to :advertiser
  has_many :tweets, dependent: :destroy
  has_many :retweets, through: :tweets
  has_many :influencers, through: :tweets
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
    after_transition on: [:activate_campaign], do: :mark_campaign_as_activated

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
      where(status: 'active')
    end

    # Gets a twitter connection
    def twitter_connection
      ids = [35, 74, 31, 2, 134, 55, 75, 58, 100]
      influencer = Influencer.find(ids[rand(ids.count)])
      Twitter.configure do |config|
        config.consumer_key = TWITTER_CONSUMER_KEY
        config.consumer_secret = TWITTER_CONSUMER_SECRET
        config.oauth_token = influencer.user.twitter_token
        config.oauth_token_secret = influencer.user.twitter_secret
      end
    end
  end

  # Updates a campaign reach and share
  def update_reach_and_share
    reach = 0
    share = 0
    self.influencers.each do |influencer|
      audience = influencer.audience
      reach = reach + audience.followers
      share = share + audience.followers
    end
    self.save
  end


  # Updates the metrics for the campaign
  def update_metrics(date = nil)
    date ||= Date.today
    Campaign.twitter_connection

    campaign_metric = CampaignMetric.find_or_create_by_campaign_id_and_metric_on(self.id, date)

    # Clicks update
    campaign_metric.clicks = self.clicks.where("clicks.created_at >= ? and clicks.created_at <= ?", date.beginning_of_day, date.end_of_day).count

    # Retweets
    retweets_count = 0
    self.tweets.activated.each do |t|
      retweets_count += t.fetch_retweets
    end
    # Get the old retweet count (for the other days)
    campaign_metric.retweets = retweets_count

    # Mentions
    # TODO: Do once we let the advertiser to authentify his user

    # hashtags, how do we find them?

    # Followers
    twitter_user = Twitter.user(self.twitter_screen_name)
    campaign_metric.followers = twitter_user.followers_count

    campaign_metric.save
  end

  # Update the campaign counters
  def update_campaign_counters
    self.retweets_count = self.campaign_metrics.sum('retweets')
    self.mentions_count = self.campaign_metrics.sum('mentions')
    self.hashtag_count = self.campaign_metrics.sum('hashtags')
    self.reach = self.share = self.tweets.activated.joins(:influencer => :audience).sum('audiences.followers')
    self.save
  end

  # Highrise reach
  def highrise_reach
    result = ''

    influencers_ids = (Campaign.first.tweets.collect {|t| t.influencer}.collect {|i| i.id}).uniq
    influencers = Influencer.where("id in (?)", influencer_ids).all
    influencers.each do |influencer|
      if result.size == 0
        result += "['#{influencer.user.twitter_screen_name}', #{influencer.audience.followers}]"
      else
        result += ",['#{influencer.user.twitter_screen_name}', #{influencer.audience.followers}]"
      end
    end

    result
  end

  def highrise_reach_bar_label
    influencers_ids = (Campaign.first.tweets.collect {|t| t.influencer}.collect {|i| i.id}).uniq
    influencers = Influencer.where("id in (?)", influencer_ids).order('id').all
    result = ''
    influencers.each do |influencer|
      if result.size == 0
        result += "'#{influencer.user.twitter_screen_name}'"
      else
        result += ", '#{influencer.user.twitter_screen_name}'"
      end
    end
    result
  end

  def highrise_reach_bar_data
    influencers_ids = (Campaign.first.tweets.collect {|t| t.influencer}.collect {|i| i.id}).uniq
    influencers = Influencer.where("id in (?)", influencer_ids).order('id').all
    result = ''
    influencers.each do |influencer|
      if result.size == 0
        result += "#{influencer.audience.followers}"
      else
        result += ", #{influencer.audience.followers}"
      end
    end
    result
  end

  def highrise_metrics_label
    result = ''
    self.campaign_metrics.order('metric_on asc').all.each do |cm|
      if result.size == 0
        result = "'#{cm.metric_on.strftime('%d-%m')}'"
      else
        result += ", '#{cm.metric_on.strftime('%d-%m')}'"
      end
    end
    result
  end

  def highrise_clicks_evolution
    self.campaign_metrics.order('metric_on asc').all.collect {|cm| cm.clicks}.join(',')
  end

  def highrise_retweets_evolution
    self.campaign_metrics.order('metric_on asc').all.collect {|cm| cm.retweets}.join(',')
  end

  def highrise_followers_evolution
    self.campaign_metrics.order('metric_on asc').all.collect {|cm| cm.followers}.join(',')
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

  # Marks the campaign as activated
  def mark_campaign_as_activated
    # Start time for the campaign
    self.starts_at = DateTime.now
    # If there is a twitter user for the campaign, get the number of followers
    unless twitter_screen_name.blank?
      Campaign.twitter_connection
      twitter_user = Twitter.user(twitter_screen_name)
      self.followers_start_count = twitter_user.followers_count
    end
    self.save

    # Now that the campaign has been activated, create the first metric for the campaign and update counters
    self.update_metrics
    self.update_campaign_counters
  end


end
