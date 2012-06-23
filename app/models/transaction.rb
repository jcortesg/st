class Transaction < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true
  belongs_to :user

  before_save :set_balance
  after_save :update_user_balance

  attr_accessible :attachable, :attachable_id, :attachable_type, :user, :user_id, :transaction_on, :transaction_type,
                  :details, :borwin_transaction, :amount, :balance

  validates_inclusion_of :transaction_type, :on => ['initial_fee', 'payment', 'tweet_fee', 'tweet_revenue',
                                                    'influencer_referrer_fee', 'advertiser_referrer_fee', 'tweet_borwin_fee']

  # Sets the balance before saving the record
  def set_balance
    if user
      self.balance = user.balance + self.amount
    elsif borwin_transaction?
      self.balance = User.find(1).balance + self.amount
    else
      raise "Error, no user for balance"
    end
  end

  # After a transaction is saved, udpate the user transactions
  def update_user_balance
    if user
      user.update_attribute(:balance, self.balance)
    elsif borwin_transaction?
      User.find(1).update_attribute(:balance, self.balance)
    else
      raise "Error, no user for balance"
    end
  end

end
