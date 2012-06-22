class Keyword < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  attr_accessible :name, :keywords
end
