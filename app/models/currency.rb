class Currency < ActiveRecord::Base
  has_many :transactions
  
  def full_status
  	return (self.status == "A" ? "Activo" : "Inactivo")
  end
end