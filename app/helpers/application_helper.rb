# encoding: utf-8
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
    value.blank? || value.size == 0 ? '&nbsp;'.html_safe : value
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
      when 'admin'
        admin_dashboard_update_password_path
    end
  end

  # Gets the url to twitter
  def twitter_url(username)
    "https://twitter.com/#!/#{username}"
  end


  # Explains the current status of the tweet
  def tweet_status_explanation(status)
    case status
      when 'created'
        'Pendiente de aprobación o rechazo por la celebridad'
      when 'influencer_reviewed'
        'Pendiente de aprobación o rechazo por el anunciante'
      when 'influencer_rejected'
        'Rechazado por la celebridad'
      when 'advertiser_reviewed'
        'Pendiente de aprobación o rechazo por la celebridad'
      when 'advertiser_rejected'
        'Rechazado por el anunciante'
      when 'accepted'
        'Aceptado, se publicara en la fecha y hora convenidas'
      when 'activated'
        'Activo, el Tweet ya fue públicado'
    end
  end

  # Gets a link for the admin to a user
  def admin_link_to_user(user)
    case user.role
      when 'influencer'
        link_to(user.full_name, admin_influencer_path(user.influencer))
      when 'affiliate'
        link_to(user.full_name, admin_affiliate_path(user.affiliate))
      when 'advertiser'
        link_to(user.full_name, admin_advertiser_path(user.advertiser))
    end
  end

  # Gets a nice description for a tranasction type
  def transaction_type_description(transaction_type)
    case transaction_type
      when 'initial_fee'
        'Fee de Campaña'
      when 'payment'
        'Pago'
    end
  end
end