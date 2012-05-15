# encoding: utf-8
class Influencer::TransactionsController < ApplicationController
  before_filter :authenticate_user!, :check_twitter_linked, :require_influencer

  # Shows the influencer income
  def index

  end
end
