# encoding: utf-8
class Influencer::TweetsController < ApplicationController
  before_filter :authenticate_user!, :check_twitter_linked, :require_influencer

  # Shows the tweets for the influencer
  def index
    @search = Tweet.where(influencer_id: current_role.id).search(params[:search])
    @tweets = @search.page(params[:page])
  end

  # Shows the details of a tweet
  def show
    @tweet = current_role.tweets.find(params[:id])
  end

  # Shows the form to modify a tweet proposition
  def edit
    @tweet = current_role.tweets.find(params[:id])
    unless ['created', 'advertiser_reviewed'].include?(@tweet.status)
      flash[:notice] = "El estado actual del tweet no permite su modificación"
      redirect_to action: index
    end
  end

  # Process the tweet modification proposition
  def update
    @tweet = current_role.tweets.find(params[:id])
    unless ['created', 'advertiser_reviewed'].include?(@tweet.status)
      flash[:notice] = "El estado actual del tweet no permite su modificación"
      redirect_to action: index and return
    end
    if @tweet.update_attributes(params[:tweet])
      flash[:success] = "El Tweet fue modificado y remitido al anunciante para su evaluación"
      redirect_to [:influencer, @tweet]
    else
      flash.now[:error] = "El Tweet no pudo ser modificado"
      render action: :edit
    end
  end

  # Accepts a twitter proposition
  def accept
    @tweet = current_role.tweets.find(params[:id])
    unless ['created', 'advertiser_reviewed'].include?(@tweet.status)
      flash[:notice] = "El estado actual del tweet no permite su aceptación"
      redirect_to action: index and return
    end
    @tweet.influencer_accept
    flash[:success] = "El Tweet ha sido aceptado"
    redirect_to [:influencer, @tweet]
  end

  # Rejects a tweet
  def destroy
    @tweet = current_role.tweets.find(params[:id])
    unless ['created', 'advertiser_reviewed'].include?(@tweet.status)
      flash[:notice] = "El estado actual del tweet no permite su rechazo"
      redirect_to action: index and return
    end
    @tweet.influencer_reject
    flash[:success] = "El Tweet ha sido rechazado"
    redirect_to [:influencer, @tweet]
  end
end
