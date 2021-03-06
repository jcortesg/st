# encoding: utf-8
class Influencer::DashboardController < ApplicationController
  before_filter :authenticate_user!, :check_twitter_linked, :require_influencer

  # Shows the dashboard for the influencer
  def index
    redirect_to influencer_profile_path
  end
end
