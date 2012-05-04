# encoding: utf-8
class User < ActiveRecord::Base
  has_one :advertiser, dependent: :destroy
  has_one :influencer, dependent: :destroy
  has_one :affiliate, dependent: :destroy

  has_one :referral_destination, :as => :referral, :conditions => 'destination_id = #{self.id}'
  has_many :referral_sources, :as => :referral, :conditions => 'source_id = #{self.id}'
  has_many :message_destinations, :as => :message, :conditions => 'destination_id = #{self.id}'
  has_many :message_sources, :as => :message, :conditions => 'source_id = #{self.id}'
      
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :affiliate_attributes, :advertiser_attributes, :influencer_attributes

  validates :email, presence: true, format: { with: /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/ }
  validates :password, presence: true, length: { within: 6..20 }
  validates :password_confirmation, presence: true, length:  { :within => 6..20, if: :password_confirmation }

  accepts_nested_attributes_for :affiliate
  accepts_nested_attributes_for :advertiser
  accepts_nested_attributes_for :influencer

  validates :role, inclusion: {in: %w(admin advertiser affiliate influencer)}

  class << self
    # Shows the accounts that are waiting for approbation
    def awaiting_aproval
      where(approved: false)
    end

    # Shows the account that are active
    def active
      where(approved: true)
    end
  end

                                                                      
  ####################
  #TODO: Remove this method
  def setaudience(params) 
    if self.role == "influencer"
      @influencer = self.influencer
      
      @audience = Audience.find_by_influencer_id(@influencer.id)
      @audience.males = params[:influencer][:males]
      @audience.klout = params[:influencer][:klout]
      @audience.peerindex = params[:influencer][:peer_index]
      @audience.retweets = params[:influencer][:retweets]
      @audience.moms = params[:moms]
      @audience.sports = params[:sports]
      @audience.save
      
      @influencer.borwin_fee = params[:influencer][:borwin_fee]
      @influencer.save
    end
    
    self.approved = true 
    self.save
        
    Notifier.approve(self).deliver
  end
  ####################


  # Check that the twitter name has been assigned and that is not already on the deb
  def check_twitter_screen_name
    if self.twitter_screen_name.blank? || User.where(twitter_screen_name: self.twitter_screen_name).exists?
      if self.twitter_screen_name.blank?
        errors.add(:twitter_screen_name, 'no puede estar en blanco')
      else
        errors.add(:twitter_screen_name, 'ya esta en uso')
      end
      false
    else
      true
    end
  end

  # Disables a user account
  def disapprove
    self.approved = false
    self.save(:validate => false)
    
    Notifier.disapprove(self).deliver
  end 

  # Approves a user account
  def approve
    self.approved = true
    self.save(:validate => false)

    Notifier.approve(self).deliver
  end

  # Tells devise if the account is confirmed to sign_in
  def active_for_authentication?
    super && approved? 
  end 

  # The message to be shown if the account is disabled
  def inactive_message 
    if !approved? 
      :not_approved 
    else 
      super
    end 
  end

  # Gets the current user role translated
  def full_user
    case self.role
      when 'influencer'
        'Celebridad'
      when 'advertiser'
        'Anunciante'
      when 'affiliate'
        'Agencia'
      when 'admin'
        'Administrador'
      else
        self.role
    end
  end
  
  # Checks if the current user is an admin
  def admin?
    role == 'admin'
  end

  # Checks if the current user is an affiliate
  def affiliate?
    role == 'affiliate'
  end

  # Checks if the current user is an advertiser
  def advertiser?
    role == 'advertiser'
  end

  # Checks if the current user is a influencer
  def influencer?
    role == 'influencer'
  end
end