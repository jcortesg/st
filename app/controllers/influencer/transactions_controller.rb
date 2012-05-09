# encoding: utf-8
class Influencer::TransactionsController < ApplicationController
  before_filter :authenticate_user!, :require_advertiser, :check_twitter_linked

  # Shows the influencer income
  def index

  end
end
