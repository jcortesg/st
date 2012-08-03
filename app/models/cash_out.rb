class CashOut < ActiveRecord::Base
  belongs_to :user
  has_many :transactions, dependent: :nullify

  attr_accessible :amount, :user_id, :user, :paid_at

  validates :status, inclusion: { in: ['created', 'paid'] }

end
