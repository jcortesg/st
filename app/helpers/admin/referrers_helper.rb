module Admin::ReferrersHelper
  def sorted_referrer_list
    referrers = User.where("role = 'influencer' or role = 'affiliate'").all
    referrers.sort_by { |u| u.full_name }
  end

  def sorted_referral_list
    referrals = User.where("role = 'influencer' or role = 'advertiser'").all
    referrals.sort_by { |u| u.full_name }
  end
end
