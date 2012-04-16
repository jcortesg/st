class PaymentType < ActiveRecord::Base
  has_many :tweets

  attr_accessible :name, :description, :status
    
  def full_status
    self.status == "A" ? "Activo" : "Inactivo"
  end
end