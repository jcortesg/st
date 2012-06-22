class Keyword < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  attr_accessible :name, :keywords

  before_save :normalize_keywords

  def normalize_keywords
    self.keywords = self.keywords.to_s.gsub(/ +,/, ',').gsub(/, +/, ',').gsub(/ +/, ' ').gsub("\n", "").gsub("-", ",").downcase
  end
end
