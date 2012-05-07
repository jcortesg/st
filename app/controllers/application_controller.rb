class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all

  # Can can recover
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end

  # Redirection after sign in with devise
  def after_sign_in_path_for(resource_or_scope)
    home_path_for(resource_or_scope)
  end

  # Redirect after sign out with devise
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

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

  # Checks that the logged in user is an admin
  def require_admin
    current_user && current_user.role == 'admin'
  end

  # Check that the influencer logged in has his twitter account linke
  def check_twitter_linked
    unless current_user.twitter_linked?
      redirect_to link_twitter_influencer_registration_path
    end
  end


end