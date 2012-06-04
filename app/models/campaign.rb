class Campaign < ActiveRecord::Base
  belongs_to :advertiser
  has_many :tweets, dependent: :destroy
  has_many :clicks, through: :tweets, dependent: :destroy

  serialize :locations, Array

  attr_accessible :name, :objective, :locations, :males, :females, :moms, :teens, :college_students,
                  :young_women, :young_men, :adult_women, :adult_men, :sports, :fashion, :music,
                  :movies, :politics, :followers_quantity

  validates :name, uniqueness: { scope: :advertiser_id }
  validates :objective, presence: true

  validates :followers_quantity, presence: true, on: :update

  class << self
    # Brings the archived campaigns
    def archived
      where(archived: true)
    end

    # Brings the active campaigns
    def active
      where(archived: false)
    end
  end

end
