class Payment < ActiveRecord::Base
  belongs_to :user
  attr_accessible :amount, :description, :status, :user_id ,:gateway, :payment_url, :external_reference, :user
end
