module ApplicationHelper
  # Gets the home path for the current user profiles
  def home_path_for(user)
    case user.role
      when 'admin'
        admin_dashboard_path
      when 'advertiser'
        #advertiser_dashboard_path
        advertiser_campaigns_path
      when 'affiliate'
        #affiliate_dashboard_path
        affiliate_referrals_path
      when 'influencer'
        if user.twitter_linked?
          influencer_profile_path
        else
          link_twitter_influencer_registration_path
        end
      #influencer_dashboard_path
    end
  end

  # Shows a value or &nbsp; for the dl tag
  def dl_value(value)
    value.nil? || value.size == 0 ? '&nbsp;'.html_safe : value
  end

  # Gets the change password path for the current user
  def change_password_path(user)
    case user.role
      when 'affiliate'
        affiliate_profiles_update_password_path
      when 'advertiser'
        advertiser_profiles_update_password_path
      when 'influencer'
        influencer_profiles_update_password_path
    end
  end
end