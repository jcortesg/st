# encoding: utf-8
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
    if resource_or_scope.role == 'influencer'
      if resource_or_scope.influencer.tweets.where("tweets.status = 'advertiser_review' or tweets.status = 'created'").count > 0
        flash[:notice] = "Tiene Tweets pendiente de aprobación. <a href='/influencer/tweets'>Revisar Tweets.</a>".html_safe
      end
    elsif resource_or_scope.role == 'advertiser'
      if resource_or_scope.advertiser.tweets.where(influencer_id: resource_or_scope.id).where("tweets.status = 'influencer_review'").count > 0
        flash[:notice] = "Tiene Tweets pendiente de aprobación. <a href='/influencer/tweets'>Revisar Tweets.</a>".html_safe
      end
    end

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
        advertiser_campaigns_path
        #advertiser_dashboard_path
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

  # Checks that the logged in user is an admin
  def require_admin
    unless current_user && current_user.role == 'admin'
      flash[:error] = "Usted no es un administrador"
      redirect_to(current_user ? home_path_for(current_user) : root_path)
    end
  end

  # Checks that the logged in user is a influencer
  def require_influencer
    unless current_user && current_user.role == 'influencer'
      flash[:error] = "Usted no es una celebridad"
      redirect_to(current_user ? home_path_for(current_user) : root_path)
    end
  end

  # Checks that the logged in user is an affiliate
  def require_affiliate
    unless current_user && current_user.role == 'affiliate'
      flash[:error] = "Usted no es una agencia"
      redirect_to(current_user ? home_path_for(current_user) : root_path)
    end
  end

  # Checks that the logged in user is an advertiser
  def require_advertiser
    unless current_user && current_user.role == 'advertiser'
      flash[:error] = "Usted no es un anunciante"
      redirect_to(current_user ? home_path_for(current_user) : root_path)
    end
  end

  # Check that the influencer logged in has his twitter account linke
  def check_twitter_linked
    unless current_user.twitter_linked?
      redirect_to link_twitter_influencer_registration_path
    end
  end

  # Gets the current role
  def current_role
    case current_user.role
      when 'advertiser'
        current_user.advertiser
      when 'influencer'
        current_user.influencer
      when 'affiliate'
        current_user.affiliate
      else
        nil
    end
  end

  # Verifies that the current user can create a campaign
  def verify_can_create_campaign
    unless current_user.advertiser.can_create_campaigns?
      flash[:error] = "No tiene permitido create campañas"
      redirect_to action: :index
    end
  end
end