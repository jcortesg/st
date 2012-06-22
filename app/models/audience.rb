# encoding: utf-8
class Audience < ActiveRecord::Base
  belongs_to :influencer

  attr_accessible :followers, :followers_followers, :friends, :tweets, :retweets, :peerindex, :klout,
                  :males, :females, :kids, :young_teens, :mature_teens, :young_adults, :mature_adults,
                  :adults, :elderly, :sports, :fashion, :music, :movies, :politics, :technology,
                  :travel, :luxury

  validates :followers, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :friends, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :tweets, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :retweets, presence: true, numericality: { greater_than_or_equal_to: 0 }

  validates :males, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :females, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :moms, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :teens, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :college_students, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :young_women, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :young_men, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :adult_women, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :adult_men, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  validates :sports, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :fashion, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :music, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :movies, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :politics, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :technology, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :travel, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :luxury, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }


  def hobbies_others
    100 - sports - fashion - music - movies - politics - technology - travel - luxury
  end

  def country_others
    100 - country_argentina - country_colombia - country_chile - country_ecuador - country_paraguay - country_uruguay
  end

  def state_others
    100 - state_buenos_aires - state_catamarca - state_chaco - state_cordoba - state_corrientes - state_entre_rios -
      state_formosa - state_jujuy - state_la_pampa - state_la_rioja - state_mendoza - state_misiones - state_neuquen -
      state_rio_negro - state_salta - state_san_juan - state_san_luis - state_santa_cruz - state_santa_fe -
      state_sgo_del_estero - state_tierra_del_fuego - state_tucuman
  end
end