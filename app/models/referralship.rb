class Referralship
  include ActiveAttr::Model

  attribute :referrer
  attribute :referral
  attribute :referral_on

  attr_accessible :referrer, :referral, :referral_on

  validates :referrer, presence: true
  validates :referral, presence: true
  validates :referral_on, presence: true
  validate :not_same_user

  def not_same_user
    if !referrer.blank? && referrer == referral
      errors.add(:referral, "El Usuario no puede referirse a si mismo")
    end
  end
end