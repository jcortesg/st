class User < ActiveRecord::Base
  has_one :advertiser, :as => :user, :conditions => "user_type = 'advertiser'"
  has_one :influencer, :as => :user, :conditions => "user_type = 'influencer'"
  has_one :affiliate, :as => :user, :conditions => "user_type = 'affiliate'"
  has_one :twitter_credential
  has_one :referral_destination, :as => :referral, :conditions => 'destination_id = #{self.id}'
  has_many :referral_sources, :as => :referral, :conditions => 'source_id = #{self.id}'
  has_many :message_destinations, :as => :message, :conditions => 'destination_id = #{self.id}'
  has_many :message_sources, :as => :message, :conditions => 'source_id = #{self.id}'
      
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :timeoutable, :confirmable

  attr_accessible :email, :password, :password_confirmation, :remember_me
                                                              
  scope :awaitingapproval, :conditions => "approved = false AND confirmed_at IS NOT NULL", :order => "created_at DESC" 
  scope :active, :conditions => "approved = true", :order => "created_at DESC"
  
  validates :password_confirmation, :presence => true, :length => { :within => 6..50, :if => :password_confirmation }

  validates :user_type, inclusion: {in: %w(administrator advertiser affiliate influencer)}
                                                                      
  ####################
  def setaudience(params) 
    if self.user_type == "influencer"
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

  def self.all_except_admin
    self.where("user_type != 'administrator'").order("approved DESC, confirmed_at DESC")
  end

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
    if user.is? :advertiser
      Advertiser.advertiser_for_user(self)
    elsif user.is? :influencer
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

  def full_user_type
    case self.user_type
      when 'influencer'
        'Celebridad'
      when 'advertiser'
        'Anunciante'
      when 'affiliate'
        'Agencia'
      when 'administrator'
        'Administrador'
      else
        self.user_type
    end
  end
  
  def is?(user_type)
    self.user_type == user_type.to_s
  end
end