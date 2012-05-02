class Influencer::CampaignsController < ApplicationController
  before_filter :authenticate_user!

  # Shows the campaigns for the influencer
  def index

  end
end
