class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end

  def after_sign_in_path_for(resource_or_scope)
    if resource_or_scope.advertiser?
      @entity = Advertiser.advertiser_for_user(resource_or_scope)
      set_user_session_values(@entity.id, @entity.twitter_username)
    elsif resource_or_scope.influencer?
      @entity = Influencer.influencer_for_user(resource_or_scope)
      set_user_session_values(@entity.id, @entity.twitter_username)
    elsif resource_or_scope.affiliate?
      @entity = Affiliate.affiliate_for_user(resource_or_scope)
      set_user_session_values(@entity.id, "@" + @entity.firstname.downcase[0] + @entity.lastname.downcase)
    elsif resource_or_scope.admin?
      set_user_session_values("0", "@admin")
    else
      super
    end
  end

  def set_user_session_values(id, name)
    user_session[:entity_id] = id
    user_session[:entity_name] = name
  end

  def after_sign_out_path_for(resource_or_scope)
    send("root_path")
  end

  def current_entity_id
    user_session[:entity_id].to_s
  end

  def current_entity_name
    user_session[:entity_name].to_s
  end

end