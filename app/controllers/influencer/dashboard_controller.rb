class Influencer::DashboardController < ApplicationController
  before_filter :authenticate_user!

  # Shows the dashboard for the influencer
  def index

  end
end
