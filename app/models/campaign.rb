class Campaign < ActiveRecord::Base
  has_many :tweets
  belongs_to :advertiser
   
  def full_status
  	return (self.status == "A" ? "Activa" : "Finalizada")
  end
end