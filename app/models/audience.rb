# encoding: utf-8
class Audience < ActiveRecord::Base
  belongs_to :influencer

  attr_accessible :followers, :followers_followers, :friends, :tweets, :retweets, :peerindex, :klout,
                  :males, :moms, :kids, :young_teens, :mature_teens, :young_adults, :mature_adults,
                  :adults, :elderly, :sports, :fashion, :music, :movies, :politics

  validates :followers, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :followers_followers, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :friends, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :tweets, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :retweets, presence: true, numericality: {greater_than_or_equal_to: 0}

  validates :males, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 1}
  validates :moms, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 1}
  validates :kids, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 1}
  validates :young_teens, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 1}
  validates :mature_teens, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 1}
  validates :young_adults, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 1}
  validates :mature_adults, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 1}
  validates :adults, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 1}
  validates :elderly, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 1}
end