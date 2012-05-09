class Affiliate::TransactionsController < ApplicationController
  before_filter :authenticate_user!, :require_advertiser

  # Shows the influencer income
  def index

  end

end
