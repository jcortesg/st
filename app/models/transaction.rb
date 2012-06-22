class Transaction < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true
  belongs_to :user

  attr_accessible :attachable, :attachable_id, :attachable_type, :user, :user_id, :transaction_on, :type, :details,
                  :borwin_transaction, :amount, :balance

  after_save :update_user_balance

  # After a transaction is saved, udpate the user transactions
  def update_user_balance
    user.update_attribute(:balance, self.balance) unless user.blank?
  end

end
