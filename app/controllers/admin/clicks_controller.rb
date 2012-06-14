#encoding: utf-8
class Admin::ClicksController < ApplicationController
  before_filter :find_campaign_and_tweet

  def index
    search_params = params[:search] || {}
    search_params.reverse_merge!({"meta_sort" => "created_at.desc"})

    if @tweet
      @search = Click.where(tweet_id: @tweet.id).search(params[:search])
    else
      @search = Click.where("tweet_id in (?)", @campaign.tweets.all.collect { |t| t.id }).search(params[:search])
    end
    @clicks = @search.page(params[:page])
  end

  private

  def find_campaign_and_tweet
    @campaign = Campaign.find(params[:campaign_id])
    @tweet = @campaign.tweets.find(params[:tweet_id]) if params[:tweet_id]
  end
end
