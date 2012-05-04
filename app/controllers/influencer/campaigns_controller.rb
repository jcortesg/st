# encoding: utf-8
class Influencer::CampaignsController < ApplicationController
  before_filter :authenticate_user!, :check_twitter_linked

  # Shows the campaigns for the influencer
  def index

  end
end
