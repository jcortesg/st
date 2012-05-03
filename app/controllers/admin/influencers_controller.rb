class Admin::InfluencersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_admin

  # Show the list of influencers
  def index

  end
end
