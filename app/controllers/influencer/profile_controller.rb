class Influencer::ProfileController < ApplicationController
  # Shows the influencer profile
  def show
    @influencer = current_user.influencer
    @twitter_user = Twitter.user(@influencer.user.twitter_screen_name)
  end
end
