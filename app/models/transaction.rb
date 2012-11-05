class Transaction < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true
  belongs_to :user
  belongs_to :cash_out

  before_save :set_balance
  after_save :update_user_balance, :notify_referrer

  attr_accessible :attachable, :attachable_id, :attachable_type, :user, :user_id, :transaction_at, :transaction_type,
                  :details, :borwin_transaction, :amount, :balance, :referrer_id

  validates :transaction_type, inclusion: { in: ['initial_fee', 'payment', 'tweet_fee', 'tweet_revenue',
                                                 'influencer_referrer_fee', 'advertiser_referrer_fee', 'tweet_borwin_fee'] }

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

  # After a transaction is saved, update the user transactions
  def update_user_balance
    if user
      user.update_attribute(:balance, self.balance)
    elsif borwin_transaction?
      User.find(1).update_attribute(:balance, self.balance)
    else
      raise "Error, no user for balance"
    end
  end

  def notify_referrer
    if referrer_id && user && user.mail_on_referral_profit
      if transaction_type == 'advertiser_referrer_fee'
        notification_user = User.find(referrer_id)
        if ! notification_user.nil?
          Notifier.referral_earnings(user, notification_user)
        end
      elsif transaction_type == 'influencer_referrer_fee'
        notification_user = Influencer.find(referrer_id)
        if ! notification_user.nil?
          Notifier.referral_earnings(user, notification_user)
        end
      end
    end
  end

end
