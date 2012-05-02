class Influencer::ReferralsController < ApplicationController
  before_filter :authenticate_user!

  # Shows the influencer referrals
  def index
    @referrals = Referral.referrals_list_with_full_details(current_user)
  end
end
