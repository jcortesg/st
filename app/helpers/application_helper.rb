module ApplicationHelper
  # Gets the home path for the current user profiles
  def home_path_for(user)
    case user.role
      when 'admin'
        admin_dashboard_path
      when 'advertiser'
        advertiser_dashboard_path
      when 'affiliate'
        affiliate_dashboard_path
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

  # TODO: Delete
  def current_entity_id
    user_session[:entity_id].to_s
  end

  # TODO: Delete
  def current_entity_name
    user_session[:entity_name].to_s
  end
end