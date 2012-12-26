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
        'Pendiente de aprobación por la celebridad'
      when 'influencer_reviewed'
        'Pendiente de aprobación por el anunciante'
      when 'influencer_rejected'
        'Rechazado por la celebridad'
      when 'advertiser_reviewed'
        'Pendiente de aprobación por la celebridad'
      when 'advertiser_rejected'
        'Rechazado por el anunciante'
      when 'accepted'
        'Aceptado, se publicara en la fecha y hora convenidas'
      when 'activated'
        'Activo, el Tweet ya fue públicado'
      when 'expired'
        'Vencido, el Tweet no fue aceptado ni rechazado'
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
        'Pago de Borwin'
      when 'tweet_fee'
        'Públicación Tweet'
      when 'tweet_revenue'
        'Ingreso por Tweet'
      when 'influencer_referrer_fee'
        'Comisión referido de Celebridad'
      when 'advertiser_referrer_fee'
        'Comisión referido de Anunciante'
      when 'tweet_borwin_fee'
        'Comisión por Tweet para Borwin'
    end
  end

  # Bank options for forms
  def bank_options
    case APP_CONFIG['app_country']
      when 'AR'
        ["Banco Ciudad", "Banco Credicoop", "Banco Comafi", "Banco Francés", "Banco Galicia", "Banco Hipotecario", "Banco Macro", "Banco Nación", "Banco Patagonia", "Banco Provincia", "City Bank", "Santander Río", "Standard Bank","ABN AMRO Bank",
         "Banca Nazionale del Lavoro",
         "Banco Bisel",
         "Banco de Inversion y Comercio Exterior",
         "Banco Itaú",
         "Banque Nationale de Paris",
         "Banco Bansud",
         "Banco HSBC",
         "Lloyds Bank",
         "Otro"]
      when 'CO'
        ["Bancafé",
        "Banco AV Villas",
        "Banco Bilbao Vizcaya Argentaria Colombia S.A. (BBVA )",
        "Banco Caja Social BCSC",
        "Banco de Bogotá",
        "Banco de Credito",
        "Banco de la República de Colombia",
        "Banco de Occidente",
        "Banco GNB Sudameris",
        "Banco Granahorrar",
        "Banco Popular",
        "Banco Popular Colombia",
        "Banco Santander Colombia",
        "Bancoldex",
        "Bancolombia",
        "BBVA Banco Ganadero",
        "Citi Bank",
        "Colmena BCSC",
        "Colpatria",
        "Conavi",
        "Credit Suisse Representaciõn para Colombia",
        "Davivienda",
        "Deutsche Bank",
        "Helm Financial Services",
        "Megabanco",
        "UBS AG in Bogotá"
        ]
      when 'MX'
        ["HSBC - México",
        "Banamex",
        "BBVA Bancomer",
        "Santander Serfin",
        "Scotiabank Inverlat",
        "Banco Azteca",
        "Bank of America - México",
        "Grupo Financiero Banorte",
        "Banco del Bajío",
        "Banco de México",
        "Bansí",
        "BanRegio",
        "Nacional Financiera - Banca de Desarrollo",
        "Banco de Comercio Exterior",
        "Banco Nacional de Crédito Rural S.N.C.",
        "Asociación de banqueros de México",
        "Banco Nacional de Obras y Servicios Públicos"
        ]
    end
  end

  def borwin_twitter_link
    case APP_CONFIG['app_country']
      when 'AR'
        '<a href="https://twitter.com/BorwinAR" class="twitter-follow-button" data-show-count="false" data-lang="es" data-size="large">Seguir en @BorwinAR</a>'
      when 'CO'
        '<a href="https://twitter.com/borwincolombia" class="twitter-follow-button" data-show-count="false" data-lang="es" data-size="large">Seguir en @borwincolombia</a>'
      when 'MX'
        '<a href="https://twitter.com/borwinmexico" class="twitter-follow-button" data-show-count="false" data-lang="es" data-size="large">Seguir en @borwinmexico</a>'
    end
  end
end