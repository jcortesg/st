class Advertiser::TweetsController < ApplicationController
  # Shows the list of celebrities (based on the campaigns) to create a new tweet
  def index
    @campaign = Campaign.find(params[:campaign_id])
    @influencers = Influencer.page(params[:page]).per(50)
  end

  # Shows the form to propose a new tweet
  def new

  end

  # Creates a new tweet
  def create

  end

  # Edit a tweet
  def edit

  end

  # Updates a tweet
  def update

  end

  # Destroys a tweet
  def destroy

  end
end
