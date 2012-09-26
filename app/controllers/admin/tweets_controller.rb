# encoding: utf-8
class Admin::TweetsController < ApplicationController
  before_filter :find_campaign

  # Shows the tweets
  def index
    @search = Tweet.search(params[:search])
    @tweets = @search.page(params[:page])
  end

  # Shows the details of a tweet
  def show
    @tweet = Tweet.find(params[:id])
  end

  # Shows the form to modify a tweet
  def edit
    @tweet = Tweet.find(params[:id])
  end

  # Process the tweet modification
  def update
    @tweet = Tweet.find(params[:id])
    if @tweet.update_attributes(params[:tweet])
      flash[:success] = "El Tweet fue modificado"
      redirect_to [:admin, @campaign, @tweet]
    else
      flash.now[:error] = "El Tweet no pudo ser modificado"
      render action: :edit
    end
  end

  # Delete a tweet
  def destroy
    @tweet = Tweet.find(params[:id])
    @tweet.destroy
    flash[:success] = "El Tweet fue eliminado del sistema"
    redirect_to [:admin, @tweet]
  end


  # Shows the profile of a influencer
  def influencer_profile
    @influencer = Influencer.find(params[:influencer_id])
    @twitter_user = Twitter.user(@influencer.user.twitter_screen_name)
  end

  # Reject cause form
  def reject
    @tweet = Tweet.find(params[:id])
    @influencers = @tweet.campaign.influencers.uniq{|x| x.id}
    # unless ['created', 'advertiser_reviewed'].include?(@tweet.status)
    #  flash[:notice] = "El estado actual del tweet no permite su rechazo"
    #  redirect_to action: index and return
    # end
  end

  # Rejects a tweet giving a reason
  def reject_cause
    @tweet = Tweet.find(params[:id])
    #unless ['created', 'advertiser_reviewed'].include?(@tweet.status)
    #  flash[:notice] = "El estado actual del tweet no permite su rechazo"
    #  redirect_to action: index and return
    #end
    if @tweet.update_attribute(:reject_cause, params[:tweet][:reject_cause])
      @tweet.influencer_reject()
      flash[:success] = "El Tweet fue rechazado y remitido al anunciante"
      redirect_to [:admin, @tweet.campaign]
    else
      flash.now[:error] = "El Tweet no pudo ser rechazado"
      render action: :show
    end
  end

  private

  # Gets the current campaign for the controller
  def find_campaign
    @campaign = Campaign.find(params[:campaign_id])
  end
end
