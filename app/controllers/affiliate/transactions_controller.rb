class Affiliate::TransactionsController < ApplicationController
  before_filter :authenticate_user!, :require_advertiser, :check_twitter_linked
end
