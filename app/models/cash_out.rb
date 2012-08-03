class CashOut < ActiveRecord::Base
  belongs_to :user
  has_many :transactions, dependent: :nullify

  has_one :transaction_payment, dependent: :nullify, class_name: 'Transaction', foreign_key: 'cash_out_paid_id'

  attr_accessible :amount, :user_id, :user, :paid_at

  validates :status, inclusion: { in: ['created', 'paid'] }

  before_validation :set_created_status

  def status_to_s
    self.status == 'created' ? 'Solicitado' : 'Pagado'
  end

  private

  def set_created_status
    self.status ||= 'created'
  end

end
