class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end

  def after_sign_in_path_for(resource_or_scope)
    #if resource_or_scope.advertiser?
    #  @entity = resource_or_scope.advertiser
    #  set_user_session_values(@entity.id, @entity.twitter_username)
    #elsif resource_or_scope.influencer?
    #  @entity = resource_or_scope.influencer
    #  set_user_session_values(@entity.id, @entity.twitter_username)
    #elsif resource_or_scope.affiliate?
    #  @entity = resource_or_scope.affiliate
    #  set_user_session_values(@entity.id, "@#{entity.first_name.downcase[0]}#{@entity.last_name.downcase}")
    #elsif resource_or_scope.admin?
    #  set_user_session_values("0", "@admin")
    #else
    #  super
    #end
    home_path_for(resource_or_scope)
  end

  def set_user_session_values(id, name)
    user_session[:entity_id] = id
    user_session[:entity_name] = name
  end

  # Handler after the user sign outs of the website
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  def current_entity_id
    user_session[:entity_id].to_s
  end

  def current_entity_name
    user_session[:entity_name].to_s
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
        influencer_dashboard_path
    end
  end

end