class Competitor < ActiveRecord::Base
  belongs_to :advertiser
  belongs_to :competitor, :class_name => "Advertiser"
end