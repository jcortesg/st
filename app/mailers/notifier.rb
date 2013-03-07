# encoding: utf-8
class Notifier < ActionMailer::Base
  default from: "Social Target <noreply@socialtarget.net>"
  layout 'notifier'

  # Stest mail
  def test_mail
    attachments.inline['logomail.png'] = File.read(Rails.root.join('app/assets/images/logomail.png'))
    mail(to: "rorra@rorra.com.ar", subject: "Social Target test")
  end

  # Site contact
  def contact(site_contact)
    attachments.inline['logomail.png'] = File.read(Rails.root.join('app/assets/images/logomail.png'))
    @site_contact = site_contact
    case APP_CONFIG['app_country']
      when 'AR'
        mail(to: 'sebastian@socialtarget.net', subject: "Contacto @ Social Target - Its time to go social")
      when 'CO'
        mail(to: 'sebastian@socialtarget.net', subject: "Contacto @ Social Target - Its time to go social")
      when 'MX'
        mail(to: 'sebastian@socialtarget.net', subject: "Contacto @ Social Target - Its time to go social")
    end
  end

  # Error during tweet publish process
  def error_publishing(tweet)
    attachments.inline['logomail.png'] = File.read(Rails.root.join('app/assets/images/logomail.png'))
    @tweet = tweet
    mail(to: 'sebastian@socialtarget.net', cc: 'mails@rorra.com.ar', subject: "[ERROR] @ Social Target - Tweet NO publicado!!!")
  end

  # Site advertiser contact
  def advertiser_contact(site_advertiser_contact)
    attachments.inline['logomail.png'] = File.read(Rails.root.join('app/assets/images/logomail.png'))
    @site_advertiser_contact = site_advertiser_contact
    case APP_CONFIG['app_country']
      when 'AR'
        mail(to: 'sebastian@socialtarget.net', subject: "Contacto @ Social Target - Its time to go social")
      when 'CO'
        mail(to: 'sebastian@socialtarget.net', subject: "Contacto @ Social Target - Its time to go social")
      when 'MX'
        mail(to: 'sebastian@socialtarget.net', subject: "Contacto @ Social Target - Its time to go social")
    end
  end

  # A user was approved
  def approve(user)
    attachments.inline['logomail.png'] = File.read(Rails.root.join('app/assets/images/logomail.png'))

    @user = user
    mail(to: @user.email, subject: "Cuenta Activada @ Social Target - Its time to go social")
  end

  # A user was dissapproved
  def disapprove(user)
    attachments.inline['logomail.png'] = File.read(Rails.root.join('app/assets/images/logomail.png'))

    @user = user

    mail(to: user.email, subject: "Cuenta Desactivada @ Social Target - Its time to go social")
  end

  # An error has occurred
  def twitter_connection_fail()
    attachments.inline['logomail.png'] = File.read(Rails.root.join('app/assets/images/logomail.png'))

    case APP_CONFIG['app_country']
      when 'AR'
        mail(to: 'sebastian@socialtarget.net', subject: "Notificaciones @ Social Target - Error obteniendo conexiones")
      when 'CO'
        mail(to: 'sebastian@socialtarget.net', subject: "Notificaciones @ Social Target - Error obteniendo conexiones")
      when 'MX'
        mail(to: 'sebastian@socialtarget.net', subject: "Notificaciones @ Social Target - Error obteniendo conexiones")
    end


  end

  # A referral has earn money
  def referral_earnings(referrer, referral)
    @referrer = referrer
    @referral = referral

    attachments.inline['logomail.png'] = File.read(Rails.root.join('app/assets/images/logomail.png'))

    mail(to: referrer.email, subject: "Notificaciones @ Social Target - Un referido ha generado un ingreso")
  end

  # A referral has sign up
  def referral_sign_up(referrer, referral)
    @referrer = referrer
    @referral = referral

    attachments.inline['logomail.png'] = File.read(Rails.root.join('app/assets/images/logomail.png'))
    
    mail(to: referrer.email, subject: "Notificaciones @ Social Target - Tienes un nuevo referido")
  end

  # A user has sign up
  def user_sign_up(user)
    @user = user

    attachments.inline['logomail.png'] = File.read(Rails.root.join('app/assets/images/logomail.png'))

    case APP_CONFIG['app_country']
      when 'AR'
        mail(to: 'sebastian@socialtarget.net', subject: "Notificaciones @ Social Target - Nuevo usuario registrado")
      when 'CO'
        mail(to: 'sebastian@socialtarget.net', subject: "Notificaciones @ Social Target - Nuevo usuario registrado")
      when 'MX'
        mail(to: 'sebastian@socialtarget.net', subject: "Notificaciones @ Social Target - Nuevo usuario registrado")
    end

  end

  # Sends an email to the influencer to let him know that he has a new tweet proposal
  def tweet_creation(tweet)
    @tweet = tweet

    attachments.inline['logomail.png'] = File.read(Rails.root.join('app/assets/images/logomail.png'))

    mail(to: tweet.influencer.user.email, subject: "Notificaciones @ Social Target - Recibiste una propuesta para un nuevo tweet")
  end

  # Sends an email to the admin that a proposal has been created
  def tweet_creation_to_admin(tweet)
    @tweet = tweet

    attachments.inline['logomail.png'] = File.read(Rails.root.join('app/assets/images/logomail.png'))

    @screen_name = tweet.influencer.user.twitter_screen_name

    case APP_CONFIG['app_country']
      when 'AR'
        mail(to: 'sebastian@socialtarget.net', subject: "Notificaciones @ Social Target - @#{@screen_name} recibió una propuesto de Tweet")
      when 'CO'
        mail(to: 'sebastian@socialtarget.net', subject: "Notificaciones @ Social Target - @#{@screen_name} recibió una propuesto de Tweet")
      when 'MX'
        mail(to: 'sebastian@socialtarget.net', subject: "Notificaciones @ Social Target - @#{@screen_name} recibió una propuesto de Tweet")
    end

  end


  # Sends a tweet to the influencer to let him know that the tweet was reviewed
  def tweet_reviewed_by_advertiser(tweet)
    @tweet = tweet

    attachments.inline['logomail.png'] = File.read(Rails.root.join('app/assets/images/logomail.png'))

    mail(to: tweet.influencer.user.email, subject: "Notificaciones @ Social Target - Uno de tus tweets fue revisado/modificado por una celebridad")
  end

  # Sends an email to the advertiser to let him know that the tweet was reviewed
  def tweet_reviewed_by_influencer(tweet)
    @tweet = tweet

    attachments.inline['logomail.png'] = File.read(Rails.root.join('app/assets/images/logomail.png'))

    mail(to: tweet.campaign.advertiser.user.email, subject: "Notificaciones @ Social Target - Uno de tus tweets fue revisado/modificado por una empresa")
  end

  # Sends an email to the influencer to let him know that the tweet was accepted
  def tweet_accepted_by_advertiser(tweet)
    @tweet = tweet

    attachments.inline['logomail.png'] = File.read(Rails.root.join('app/assets/images/logomail.png'))

    mail(to: tweet.influencer.user.email, subject: "Notificaciones @ Social Target - Uno de tus tweets revisados, fue aceptado por una empresa y esta listo para ser públicado")
  end

  # Sends an email to the advertiser to let him know the tweet was accepted
  def tweet_accepted_by_influencer(tweet)
    @tweet = tweet

    attachments.inline['logomail.png'] = File.read(Rails.root.join('app/assets/images/logomail.png'))

    mail(to: tweet.campaign.advertiser.user.email, subject: "Notificaciones @ Social Target - Uno de tus tweets fue confirmado y esta listo para ser públicado")
  end

  # Sends an email to the influencer to let him know that the tweet was rejected
  def tweet_rejected_by_advertiser(tweet)
    @tweet = tweet

    attachments.inline['logomail.png'] = File.read(Rails.root.join('app/assets/images/logomail.png'))

    mail(to: tweet.influencer.user.email, subject: "Notificaciones @ Social Target - Una propuesta de tweet que has modificado, ha sido rechazada por el anunciante")
  end

  # Sends an email to the advertiser to let him know the tweet was rejected
  def tweet_rejected_by_influencer(tweet)
    @tweet = tweet

    attachments.inline['logomail.png'] = File.read(Rails.root.join('app/assets/images/logomail.png'))

    @screen_name = tweet.influencer.user.twitter_screen_name

    mail(to: tweet.campaign.advertiser.user.email, subject: "Notificaciones @ Social Target - Tweet rechazado por @"+@screen_name+ ". "+@tweet.reject_cause)
    case APP_CONFIG['app_country']
      when 'AR'
        mail(to: 'sebastian@socialtarget.net', subject: "Notificaciones @ Social Target - Un tweet realizado por "+tweet.campaign.advertiser.user.email+" fue rechazado por @"+@screen_name+ ". "+@tweet.reject_cause)
      when 'CO'
        mail(to: 'sebastian@socialtarget.net', subject: "Notificaciones @ Social Target - Un tweet realizado por "+tweet.campaign.advertiser.user.email+" fue rechazado por @"+@screen_name+ ". "+@tweet.reject_cause)
      when 'MX'
        mail(to: 'sebastian@socialtarget.net', subject: "Notificaciones @ Social Target - Un tweet realizado por "+tweet.campaign.advertiser.user.email+" fue rechazado por @"+@screen_name+ ". "+@tweet.reject_cause)
    end

  end

  # Sends an email to the advertiser to let him know the tweet was rejected
  def tweet_rejected_by_influencer_in_dialog(tweet)
    @tweet = tweet

    attachments.inline['logomail.png'] = File.read(Rails.root.join('app/assets/images/logomail.png'))

    @screen_name = tweet.influencer.user.twitter_screen_name

    tweet.campaign.influencers.each do |influencer|
      mail(to: influencer.user.email, subject: "Notificaciones @ Social Target - Una campaña en la que participas fue cancelada. Tweet rechazado por @"+@screen_name+ ". ")
    end

    mail(to: tweet.campaign.advertiser.user.email, subject: "Notificaciones @ Social Target - Tweet rechazado por @"+@screen_name+ ". "+@tweet.reject_cause)

    case APP_CONFIG['app_country']
      when 'AR'
        mail(to: 'sebastian@socialtarget.net', subject: "Notificaciones @ Social Target - Un tweet realizado por "+tweet.campaign.advertiser.user.email+" fue rechazado por @"+@screen_name+ ". "+@tweet.reject_cause)
      when 'CO'
        mail(to: 'sebastian@socialtarget.net', subject: "Notificaciones @ Social Target - Un tweet realizado por "+tweet.campaign.advertiser.user.email+" fue rechazado por @"+@screen_name+ ". "+@tweet.reject_cause)
      when 'MX'
        mail(to: 'sebastian@socialtarget.net', subject: "Notificaciones @ Social Target - Un tweet realizado por "+tweet.campaign.advertiser.user.email+" fue rechazado por @"+@screen_name+ ". "+@tweet.reject_cause)
    end

  end

  # Sends an email to the advertiser when a tweet is activated
  def tweet_activated_to_advertiser(tweet)
    @tweet = tweet

    attachments.inline['logomail.png'] = File.read(Rails.root.join('app/assets/images/logomail.png'))

    mail(to: tweet.campaign.advertiser.user.email, subject: "Notificaciones @ Social Target - Uno de tus tweets fue públicado")
  end

  # Sends an email to the influencer when a tweet is activated
  def tweet_activated_to_influencer(tweet)
    @tweet = tweet

    attachments.inline['logomail.png'] = File.read(Rails.root.join('app/assets/images/logomail.png'))

    mail(to: tweet.influencer.user.email, subject: "Notificaciones @ Social Target - Uno de tus tweets fue publicado")
  end

  # Sends an email to a user that was converted from an advertiser to an affiliate
  def influencer_converted_to_affiliate(user)
    attachments.inline['logomail.png'] = File.read(Rails.root.join('app/assets/images/logomail.png'))

    mail(to: user.email, subject: "Notificaciones @ Social Target - Has sido recategorizado en Social Target")
  end

  # Sends an email to an advertiser when a campaign has ended
  def campaign_ends(advertiser, campaign)
    @advertiser = advertiser
    @campaign = campaign

    attachments.inline['logomail.png'] = File.read(Rails.root.join('app/assets/images/logomail.png'))

    mail(to: advertiser.user.email, subject: "Notificaciones @ Social Target - Su campaña ha finalizado")
  end

  # Sends an email to admin alerting about a tweet expiration
  def expiration_alert_to_admin(tweet, time)
    @tweet = tweet
    @time = time.to_s

    attachments.inline['logomail.png'] = File.read(Rails.root.join('app/assets/images/logomail.png'))

    case APP_CONFIG['app_country']
      when 'AR'
        mail(to: 'sebastian@socialtarget.net', subject: "Tweet expira en "+time.to_s+" minutos - Its time to go social")
      when 'CO'
        mail(to: 'sebastian@socialtarget.net', subject: "Tweet expira en "+time.to_s+" minutos - Its time to go social")
      when 'MX'
        mail(to: 'sebastian@socialtarget.net', subject: "Tweet expira en "+time.to_s+" minutos - Its time to go social")
    end

  end

  # Sends an email to advertiser alerting about a tweet expiration
  def expiration_alert_to_advertiser(tweet, time)
    @tweet = tweet
    @time = time.to_s

    attachments.inline['logomail.png'] = File.read(Rails.root.join('app/assets/images/logomail.png'))

    mail(to: tweet.campaign.advertiser.user.email, subject: "Tweet expira en "+time.to_s+" minutos - Its time to go social")
  end

  # Sends an email to influencer alerting about a tweet expiration
  def expiration_alert_to_influencer(tweet, time)
    @tweet = tweet
    @time = time.to_s

    attachments.inline['logomail.png'] = File.read(Rails.root.join('app/assets/images/logomail.png'))

    mail(to: tweet.influencer.user.email, subject: "Tweet expira en "+time.to_s+" minutos - Its time to go social")
  end

  # Sends an email to admin alerting about low credit
  def low_credit_warning_to_admin(user)
    @user = user
    @advertiser = user.advertiser

    attachments.inline['logomail.png'] = File.read(Rails.root.join('app/assets/images/logomail.png'))

    case APP_CONFIG['app_country']
      when 'AR'
        mail(to: 'sebastian@socialtarget.net', subject: "Anunciante con crédito debajo de $1000 - Its time to go social")
      when 'CO'
        mail(to: 'sebastian@socialtarget.net', subject: "Anunciante con crédito debajo de $1000 - Its time to go social")
      when 'MX'
        mail(to: 'sebastian@socialtarget.net', subject: "Anunciante con crédito debajo de $1000 - Its time to go social")
    end

  end

  # Sends an email to advertiser alerting about low credit
  def low_credit_warning_to_advertiser(user)
    @user = user
    @advertiser = user.advertiser

    attachments.inline['logomail.png'] = File.read(Rails.root.join('app/assets/images/logomail.png'))

    mail(to: user.email, subject: "Su crédito ha disminuido a $#{sprintf('%.02f', @user.balance)} - Its time to go social")
  end

  # Sends a cash out notice to the admin
  def cash_out_notice_to_admin(cash_out)
    @cash_out = cash_out

    attachments.inline['logomail.png'] = File.read(Rails.root.join('app/assets/images/logomail.png'))

    if cash_out.user.role == 'influencer'
      subject = "La celebridad #{cash_out.user.full_name} ha solicitado un Cash Out por $#{cash_out.amount}"
    else
      subject = "La agencia #{cash_out.user.full_name} ha solicitado un Cash Out por $#{cash_out.amount}"
    end

    case APP_CONFIG['app_country']
      when 'AR'
        mail(to: 'sebastian@socialtarget.net', subject: subject)
      when 'CO'
        mail(to: 'sebastian@socialtarget.net', subject: subject)
      when 'MX'
        mail(to: 'sebastian@socialtarget.net', subject: subject)
    end
  end

  # Sends a cash out payment notice to the user
  def cash_out_paid(cash_out)
    @cash_out = cash_out

    attachments.inline['logomail.png'] = File.read(Rails.root.join('app/assets/images/logomail.png'))

    mail(to: cash_out.user.email, subject: "Notificaciones @ Social Target -  Se ha realizado el pago de un Cash Out")
  end

  def influencer_need_approval(influencer)
    @influencer = influencer

    attachments.inline['logomail.png'] = File.read(Rails.root.join('app/assets/images/logomail.png'))

    case APP_CONFIG['app_country']
      when 'AR'
        mail(to: 'sebastian@socialtarget.net', subject: "Notificaciones @ Social Target -  Usuario requiere aprobación")
      when 'CO'
        mail(to: 'sebastian@socialtarget.net', subject: "Notificaciones @ Social Target -  Usuario requiere aprobación")
      when 'MX'
        mail(to: 'sebastian@socialtarget.net', subject: "Notificaciones @ Social Target -  Usuario requiere aprobación")
    end
  end

  def influencer_rejected(influencer)
    @influencer = influencer

    attachments.inline['logomail.png'] = File.read(Rails.root.join('app/assets/images/logomail.png'))

    mail(to: influencer.user.email, subject: "Notificaciones @ Social Target -  No has sido aprobado.")
  end

  def influencer_approved(influencer)
    @influencer = influencer

    attachments.inline['logomail.png'] = File.read(Rails.root.join('app/assets/images/logomail.png'))

    mail(to: influencer.user.email, subject: "Notificaciones @ Social Target -  Has sido aprobado.")
  end
end