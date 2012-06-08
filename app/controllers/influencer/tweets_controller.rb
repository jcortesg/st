# encoding: utf-8
class Influencer::TweetsController < ApplicationController
  before_filter :authenticate_user!, :check_twitter_linked, :require_influencer

  # Shows the tweets for the influencer
  def index
    @search = Tweet.where(influencer_id: current_role.id).search(params[:search])
    @tweets = @search.page(params[:page])
  end
end
