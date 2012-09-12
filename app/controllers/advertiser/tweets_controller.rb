# encoding: utf-8
class Advertiser::TweetsController < ApplicationController
  before_filter :find_campaign
  before_filter :verify_can_create_campaign, only: [:new, :create]

  # Shows the list of celebrities (based on the campaigns) to create a new tweet
  def index
    @search = Influencer.apply_filters(@campaign)
    @search = Influencer.apply_default_sort(@campaign, @search) if params[:search].blank? || params[:search][:meta_sort].blank?
    @search = @search.search(params[:search])
    @influencers = @search.page(params[:page]).per(20)
  end

  # Shows the form to propose a new tweet
  def new
    # Get the influencer for the new tweet
    if params[:influencer_id]
      @influencer = Influencer.find(params[:influencer_id])
    else
      redirect_to action: :index
    end

    # Get the latest tweet of the influencer
    @twitter_user = Twitter.user(@influencer.user.twitter_screen_name)

    # Check if there are other tweets on this campaign with this user
    @tweets = Tweet.where(campaign_id: @campaign.id, influencer_id: @influencer.id)

    @campaigns_id = Set.new()
    @tweets.each do |tweet|
      @campaigns_id.add(tweet.campaign)
    end

    @campaigns = Campaign.where("id in (?)", @campaigns_id).limit(3).order("created_at desc")

    # New tweet with default values
    @tweet_group = TweetGroup.new
    @tweet_group.influencer_id = @influencer.id
    @tweet_group.campaign_id = @campaign.id

    @tweet_group.tweets.build(campaign_id: @campaign.id, influencer_id: @influencer.id)
    @tweet_group.tweets.build(campaign_id: @campaign.id, influencer_id: @influencer.id)
    @tweet_group.tweets.build(campaign_id: @campaign.id, influencer_id: @influencer.id)

    @picture = Picture.new
  end

  # Creates a new tweet
  def create
    @tweet_group = TweetGroup.new(params[:tweet_group])
    @influencer = Influencer.find(@tweet_group.influencer_id)
    @tweet_group.campaign = @campaign
    @tweet_group.tweets.each do |tweet|
      tweet.campaign = @campaign
      tweet.fee_type = 'tweet_fee' if @campaign.price_per_click == false
    end
    if @tweet_group.save
      flash[:success] = "Se ha propuesto el tweet a #{@influencer.full_name}"
      redirect_to advertiser_campaign_path(@campaign)
    else
      @twitter_user = Twitter.user(@influencer.user.twitter_screen_name)
      @tweets = Tweet.where(campaign_id: @campaign.id, influencer_id: @influencer.id)
      flash[:error] = "Hubo errores al proponer el tweet"
      render action: :new
    end

  end

  # Shows the tweet
  def show
    @tweet = @campaign.tweets.find(params[:id])
  end

  # Shows the form to modify a tweet proposition
  def edit
    @tweet = @campaign.tweets.find(params[:id])
    unless ['influencer_reviewed'].include?(@tweet.status)
      flash[:notice] = "El estado actual del tweet no permite su modificación"
      redirect_to action: index
    end
  end

  # Process the tweet modification proposition
  def update
    @tweet = @campaign.tweets.find(params[:id])
    unless ['influencer_reviewed'].include?(@tweet.status)
      flash[:notice] = "El estado actual del tweet no permite su modificación"
      redirect_to action: index and return
    end
    if @tweet.update_attributes(params[:tweet])
      @tweet.advertiser_review
      flash[:success] = "El Tweet fue modificado y remitido a la celebridad para su evaluación"
      redirect_to [:advertiser, @campaign, @tweet]
    else
      flash.now[:error] = "El Tweet no pudo ser modificado"
      render action: :edit
    end
  end

  # Accepts a twitter proposition
  def accept
    @tweet = @campaign.tweets.find(params[:id])
    unless ['influencer_reviewed'].include?(@tweet.status)
      flash[:notice] = "El estado actual del tweet no permite su aceptación"
      redirect_to action: index and return
    end
    @tweet.advertiser_accept
    flash[:success] = "El Tweet ha sido aceptado"
    redirect_to [:advertiser, @campaign, @tweet]
  end

  # Rejects a tweet
  def destroy
    @tweet = @campaign.tweets.find(params[:id])
    unless ['influencer_reviewed'].include?(@tweet.status)
      flash[:notice] = "El estado actual del tweet no permite su rechazo"
      redirect_to action: index and return
    end
    @tweet.advertiser_reject
    flash[:success] = "El Tweet ha sido rechazado"
    redirect_to [:advertiser, @campaign, @tweet]
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
