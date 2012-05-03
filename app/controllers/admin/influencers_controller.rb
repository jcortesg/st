class Admin::InfluencersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_admin

  # Show the list of influencers
  def index
    @search = Influencer.includes(:user).search(params[:search])
    @influencers = @search.page(params[:page])
  end
end
