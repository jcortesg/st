# encoding: utf-8
class Influencer::CampaignsController < ApplicationController
  before_filter :authenticate_user!, :require_advertiser, :check_twitter_linked

  # Shows the campaigns for the influencer
  def index

  end
end
