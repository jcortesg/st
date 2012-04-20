class Location < ActiveRecord::Base
  has_many :audience_locations
  has_many :audiences, :through => :audience_locations
    
  def full_status
  	self.status == "A" ? "Activo" : "Inactivo"
  end
end