class PaymentMethod < ActiveRecord::Base
  has_many :transactions
    
  def full_status
  	 self.status == "A" ? "Activo" : "Inactivo"
  end
end