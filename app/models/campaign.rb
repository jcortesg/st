class Campaign < ActiveRecord::Base
  belongs_to :advertiser

  validates :name, uniqueness: { scope: :advertiser_id }

  validates :min_males, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :max_males, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :min_females, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :max_females, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :min_kids, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :max_kids, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :min_young_teens, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :max_young_teens, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :min_mature_teens, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :max_mature_teens, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :min_young_adults, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :max_young_adults, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :min_mature_adults, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :max_mature_adults, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :min_adults, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :max_adults, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :min_elderly, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :max_elderly, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  validates :min_sports, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :max_sports, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :min_fashion, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :max_fashion, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :min_music, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :max_music, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :min_movies, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :max_movies, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :min_politics, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :max_politics, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

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
