# encoding: utf-8
class Advertiser::TweetsController < ApplicationController
  before_filter :find_campaign
  before_filter :verify_can_create_campaign, only: [:new, :create]

  # Shows the list of celebrities (based on the campaigns) to create a new tweet
  def index
    @influencers = Influencer.page(params[:page]).per(50)
  end

  # Shows the form to propose a new tweet
  def new
    if params[:influencer_id]
      @influencer = Influencer.find(params[:influencer_id])
    else
      redirect_to action: :index
    end
    @twitter_user = Twitter.user(@influencer.user.twitter_screen_name)
    @tweet = Tweet.new
    @tweet.influencer_id = @influencer.id
    @tweet.campaign_id = @campaign.id
  end

  # Creates a new tweet
  def create
    @tweet = Tweet.new(params[:tweet])
    @influencer = Influencer.find(@tweet.influencer_id)
    @tweet.campaign = @campaign
    if @tweet.save
      if params[:commit] == 'Proponer y volver a la campaña'
        flash[:success] = "Se ha propuesto el tweet a #{@influencer.full_name}"
        redirect_to advertiser_campaign_path(@campaign)
      else
        flash[:success] = "Se ha propuesto el tweet a #{@influencer.full_name}"
        new_advertiser_campaign_tweet_path(@campaign, influencer_id: @influencer.id)
      end
    else
      @twitter_user = Twitter.user(@influencer.user.twitter_screen_name)
      flash[:error] = "Hubo errores al proponer el tweet"
      render action: :new
    end
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

  # Shows the profile of a influencer
  def influencer_profile
    @influencer = Influencer.find(params[:influencer_id])
    @twitter_user = Twitter.user(@influencer.user.twitter_screen_name)
  end

  private

  # Gets the current campaign for the controller
  def find_campaign
    @campaign = Campaign.find(params[:campaign_id])
  end
end
