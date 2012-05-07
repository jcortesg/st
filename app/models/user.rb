# encoding: utf-8
class User < ActiveRecord::Base
  # User types
  has_one :advertiser, dependent: :destroy
  has_one :influencer, dependent: :destroy
  has_one :affiliate, dependent: :destroy

  # Referrals
  belongs_to :referrer, foreign_key: "referrer_id", class_name: "User"
  has_many :referrals, foreign_key: "referrer_id", class_name: "User"

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  before_create :set_invitation_code
  after_create :send_referral_mail

  validates :email, presence: true, format: { with: /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/ }
  validates :password, presence: true, length: { within: 6..20 }, if: :needs_password?
  validates :password_confirmation, presence: true, length:  { :within => 6..20, if: :password_confirmation }, if: :needs_password?

  accepts_nested_attributes_for :affiliate
  accepts_nested_attributes_for :advertiser
  accepts_nested_attributes_for :influencer

  validates :role, inclusion: {in: %w(admin advertiser affiliate influencer)}
  validates :invitation_code, uniqueness: true

  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :affiliate_attributes, :advertiser_attributes, :influencer_attributes,
                  :referrer_id, :referrer_on, :referrer_commission, :mail_on_referral_singup, :mail_on_referral_profit

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

  # Sets the unique invitation code for the suer
  def set_invitation_code
    o =  [('A'..'Z'),(0..9)].map{|i| i.to_a}.flatten
    begin
      code = (0..5).map{ o[rand(o.length)] }.join
    end while User.where(:invitation_code => code).exists?
    self.invitation_code = code
  end

  private

  # Just needs password if the encrypted password is not there
  def needs_password?
    encrypted_password.nil?
  end

  # Send the email to the referral if they expect an email
  def send_referral_mail
    if referrer && referrer.mail_on_referral_singup
      Notifier.referral_sign_up(self.referrer, self).deliver
    end
  end
end