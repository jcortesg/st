class PaymentType < ActiveRecord::Base
  has_many :tweets
    
  def full_status
  	return (self.status == "A" ? "Activo" : "Inactivo")
  end
end