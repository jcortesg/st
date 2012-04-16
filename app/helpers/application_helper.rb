module ApplicationHelper

  # Gets the home path for the current user profile
  def home_path_for(user)
    case user.user_type
      when 'administrator'
        admin_dashboard_path
      when 'advertiser'
        advertiser_dashboard_path
      when 'affiliate'
        affiliate_dashboard_path
      when 'influencer'
        influencer_dashboard_path
    end
  end


  # TODO: Delete
  def current_entity_id
    user_session[:entity_id].to_s
  end

  # TODO: Delete
  def current_entity_name
    user_session[:entity_name].to_s
  end

  # TODO: Delete
  def current_user_type
    current_user.user_type + "s"
  end
end