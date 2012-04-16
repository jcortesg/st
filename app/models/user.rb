class User < ActiveRecord::Base
  has_one :advertiser
  has_one :influencer
  has_one :affiliate

  has_one :twitter_credential
  has_one :referral_destination, :as => :referral, :conditions => 'destination_id = #{self.id}'
  has_many :referral_sources, :as => :referral, :conditions => 'source_id = #{self.id}'
  has_many :message_destinations, :as => :message, :conditions => 'destination_id = #{self.id}'
  has_many :message_sources, :as => :message, :conditions => 'source_id = #{self.id}'
      
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :affiliate_attributes, :advertiser_attributes, :influencer_attributes

  validates :email, presence: true, format: { with: /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/ }
  validates :password, presence: true, length: { within: 6..20 }
  validates :password_confirmation, presence: true, length:  { :within => 6..20, if: :password_confirmation }

  accepts_nested_attributes_for :affiliate
  accepts_nested_attributes_for :advertiser
  accepts_nested_attributes_for :influencer

  validates :role, inclusion: {in: %w(administrator advertiser affiliate influencer)}

  class << self
    # Shows the accounts that are waiting for approbation
    def awaiting_aproval
      where(approved: false)
    end

    # Shows the account that are active
    def active
      where(approved: true)
    end

    # Retrieve all the accounts except the administrator
    def all_except_admin
      where("role != 'administrator'").order("approved DESC")
    end
  end

                                                                      
  ####################
  def setaudience(params) 
    if self.role == "influencer"
      @influencer = Influencer.influencer_for_user(self)
      
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

  def disapprove
    self.approved = false
    self.save(:validate => false)
    
    Notifier.disapprove(self).deliver
  end 
    
  def approve     
    self.approved = true
    self.save(:validate => false)

    Notifier.approve(self).deliver
  end
  
  def get_entity_for_user
    if user.advertiser?
      Advertiser.advertiser_for_user(self)
    elsif user.influencer?
      Influencer.advertiser_for_user(self)
    else
      Affiliate.advertiser_for_user(self)
    end
  end
    
  def active_for_authentication? 
    super && approved? 
  end 

  def inactive_message 
    if !approved? 
      :not_approved 
    else 
      super
    end 
  end

  def full_user
    case self.role
      when 'influencer'
        'Celebridad'
      when 'advertiser'
        'Anunciante'
      when 'affiliate'
        'Agencia'
      when 'administrator'
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