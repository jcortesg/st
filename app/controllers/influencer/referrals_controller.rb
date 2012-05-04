# encoding: utf-8
class Influencer::ReferralsController < ApplicationController
  before_filter :authenticate_user!, :check_twitter_linked

  # Shows the influencer referrals
  def index
    @referrals = Referral.referrals_list_with_full_details(current_user)
  end
end
