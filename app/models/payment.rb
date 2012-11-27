class Payment < ActiveRecord::Base
  attr_accessible :amount, :description, :status, :user_id
end
