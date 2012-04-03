class AudiencesLocation < ActiveRecord::Base
  belongs_to :audience
  belongs_to :location
end