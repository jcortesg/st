class Advertiser::TweetsController < ApplicationController
  # Shows the list of celebrities (based on the campaigns) to create a new tweet
  def index
    @campaign = Campaign.find(params[:campaign_id])
    @influencers = Influencer.page(params[:page]).per(50)
  end

  #
  def new

  end

  def create

  end

  def edit

  end

  def update

  end

  def destroy

  end
end
