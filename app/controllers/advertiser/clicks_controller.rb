# encoding: utf-8
class Advertiser::ClicksController < ApplicationController
  before_filter :find_campaign

  def index
    @search = Click.where("tweet_id in (?)", @campaign.tweets.all.collect { |t| t.id }).search(params[:search])
    @clicks = @search.page(params[:page])
  end

  private

  def find_campaign
    @campaign = current_role.campaigns.find(params[:campaign_id])
  end
end
