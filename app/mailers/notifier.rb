# encoding: utf-8
class Notifier < ActionMailer::Base
  default from: "Borwin <noreply@borwin.net>"

  # Stest mail
  def test_mail
    mail(to: "rorra@rorra.com.ar", subject: "Borwin test")
  end

  # Site contact
  def contact(site_contact)
    @site_contact = site_contact

    mail(to: "sebastian@borwin.net", subject: "Contacto @ Borwin - Its time to go social")
  end

  # Site advertiser contact
  def advertiser_contact(site_advertiser_contact)
    @site_advertiser_contact = site_advertiser_contact

    mail(to: "sebastian@borwin.net", subject: "Contacto @ Borwin - Its time to go social")
  end

  # A user was approved
  def approve(user)
    @user = user
    attachments.inline['logo.jpg'] = File.read(Rails.root.join('app/assets/images/logo.jpg'))
    attachments.inline['sellochico.jpg'] = File.read(Rails.root.join('app/assets/images/sellochico.jpg'))
    
    mail(to: @user.email, subject: "Cuenta Activada @ Borwin - Its time to go social")
  end

  # A user was dissapproved
  def disapprove(user)
    @user = user
    attachments.inline['logo.jpg'] = File.read(Rails.root.join('app/assets/images/logo.jpg'))
    attachments.inline['sellochico.jpg'] = File.read(Rails.root.join('app/assets/images/sellochico.jpg'))
    
    mail(to: user.email, subject: "Cuenta Desactivada @ Borwin - Its time to go social")
  end

  # A referral has sign up
  def referral_sign_up(referrer, referral)
    @referrer = referrer
    @referral = referral

    attachments.inline['logo.jpg'] = File.read(Rails.root.join('app/assets/images/logo.jpg'))
    attachments.inline['sellochico.jpg'] = File.read(Rails.root.join('app/assets/images/sellochico.jpg'))
    
    mail(to: referrer.email, subject: "Notificaciones @ Borwin - Tienes un nuevo referido")
  end

  # A user has sign up
  def user_sign_up(user)
    @user = user

    attachments.inline['logo.jpg'] = File.read(Rails.root.join('app/assets/images/logo.jpg'))
    attachments.inline['sellochico.jpg'] = File.read(Rails.root.join('app/assets/images/sellochico.jpg'))

    mail(to: 'sebastian@borwin.net', subject: "Notificaciones @ Borwin - Nuevo usuario registrado")
  end

  # Sends an email to the influencer to let him know that he has a new tweet proposal
  def tweet_creation(tweet)
    @tweet = tweet

    attachments.inline['logo.jpg'] = File.read(Rails.root.join('app/assets/images/logo.jpg'))
    attachments.inline['sellochico.jpg'] = File.read(Rails.root.join('app/assets/images/sellochico.jpg'))

    mail(to: tweet.influencer.user.email, subject: "Notificaciones @ Borwin - Recibiste una propuesta para un nuevo tweet")
  end

  # Sends an email to the admin that a proposal has been created
  def tweet_creation_to_admin(tweet)
    @tweet = tweet

    attachments.inline['logo.jpg'] = File.read(Rails.root.join('app/assets/images/logo.jpg'))
    attachments.inline['sellochico.jpg'] = File.read(Rails.root.join('app/assets/images/sellochico.jpg'))

    @screen_name = tweet.influencer.user.twitter_screen_name

    mail(to: 'sebastian@borwin.net', cc: ['sofia@borwin.net', 'poli@borwin.net'], subject: "Notificaciones @ Borwin - @#{@screen_name} recibió una propuesto de Tweet")
  end


  # Sends a tweet to the influencer to let him know that the tweet was reviewed
  def tweet_reviewed_by_advertiser(tweet)
    @tweet = tweet

    attachments.inline['logo.jpg'] = File.read(Rails.root.join('app/assets/images/logo.jpg'))
    attachments.inline['sellochico.jpg'] = File.read(Rails.root.join('app/assets/images/sellochico.jpg'))

    mail(to: tweet.influencer.user.email, subject: "Notificaciones @ Borwin - Uno de tus tweets fue revisado/modificado por una celebridad")
  end

  # Sends an email to the advertiser to let him know that the tweet was reviewed
  def tweet_reviewed_by_influencer(tweet)
    @tweet = tweet

    attachments.inline['logo.jpg'] = File.read(Rails.root.join('app/assets/images/logo.jpg'))
    attachments.inline['sellochico.jpg'] = File.read(Rails.root.join('app/assets/images/sellochico.jpg'))

    mail(to: tweet.campaign.advertiser.user.email, subject: "Notificaciones @ Borwin - Uno de tus tweets fue revisado/modificado por una empresa")
  end

  # Sends an email to the influencer to let him know that the tweet was accepted
  def tweet_accepted_by_advertiser(tweet)
    @tweet = tweet

    attachments.inline['logo.jpg'] = File.read(Rails.root.join('app/assets/images/logo.jpg'))
    attachments.inline['sellochico.jpg'] = File.read(Rails.root.join('app/assets/images/sellochico.jpg'))

    mail(to: tweet.influencer.user.email, subject: "Notificaciones @ Borwin - Uno de tus tweets revisados, fue aceptado por una empresa y esta listo para ser públicado")
  end

  # Sends an email to the advertiser to let him know the tweet was accepted
  def tweet_accepted_by_influencer(tweet)
    @tweet = tweet

    attachments.inline['logo.jpg'] = File.read(Rails.root.join('app/assets/images/logo.jpg'))
    attachments.inline['sellochico.jpg'] = File.read(Rails.root.join('app/assets/images/sellochico.jpg'))

    mail(to: tweet.campaign.advertiser.user.email, subject: "Notificaciones @ Borwin - Uno de tus tweets fue confirmado y esta listo para ser públicado")
  end

  # Sends an email to the influencer to let him know that the tweet was rejected
  def tweet_rejected_by_advertiser(tweet)
    @tweet = tweet

    attachments.inline['logo.jpg'] = File.read(Rails.root.join('app/assets/images/logo.jpg'))
    attachments.inline['sellochico.jpg'] = File.read(Rails.root.join('app/assets/images/sellochico.jpg'))

    mail(to: tweet.influencer.user.email, subject: "Notificaciones @ Borwin - Una propuesta de tweet que has modificado, ha sido rechazada por el anunciante")
  end

  # Sends an email to the advertiser to let him know the tweet was rejected
  def tweet_rejected_by_influencer(tweet)
    @tweet = tweet

    attachments.inline['logo.jpg'] = File.read(Rails.root.join('app/assets/images/logo.jpg'))
    attachments.inline['sellochico.jpg'] = File.read(Rails.root.join('app/assets/images/sellochico.jpg'))

    @screen_name = tweet.influencer.user.twitter_screen_name

    mail(to: tweet.campaign.advertiser.user.email, subject: "Notificaciones @ Borwin - Una propuesta de tweet que has realizado ha sido rechazada por "+@screen_name, :body => @tweet.reject_cause)
    mail(to: 'sebastian@borwin.net', cc: ['sofia@borwin.net', 'poli@borwin.net'], subject: "Notificaciones @ Borwin - Una propuesta de tweet que ha realizado "+tweet.campaign.advertiser.user.email+" ha sido rechazada por @"+@screen_name, :body => @tweet.reject_cause)
  end

  # Sends an email to the advertiser when a tweet is activated
  def tweet_activated_to_advertiser(tweet)
    @tweet = tweet

    attachments.inline['logo.jpg'] = File.read(Rails.root.join('app/assets/images/logo.jpg'))
    attachments.inline['sellochico.jpg'] = File.read(Rails.root.join('app/assets/images/sellochico.jpg'))

    mail(to: tweet.campaign.advertiser.user.email, subject: "Notificaciones @ Borwin - Uno de tus tweets fue públicado")
  end

  # Sends an email to the influencer when a tweet is activated
  def tweet_activated_to_influencer(tweet)
    @tweet = tweet

    attachments.inline['logo.jpg'] = File.read(Rails.root.join('app/assets/images/logo.jpg'))
    attachments.inline['sellochico.jpg'] = File.read(Rails.root.join('app/assets/images/sellochico.jpg'))

    mail(to: tweet.influencer.user.email, subject: "Notificaciones @ Borwin - Uno de tus tweets fue publicado")
  end

  # Sends an email to a user that was converted from an advertiser to an affiliate
  def influencer_converted_to_affiliate(user)
    attachments.inline['logo.jpg'] = File.read(Rails.root.join('app/assets/images/logo.jpg'))
    attachments.inline['sellochico.jpg'] = File.read(Rails.root.join('app/assets/images/sellochico.jpg'))

    mail(to: user.email, subject: "Notificaciones @ Borwin - Has sido recategorizado en Borwin")
  end

  # Sends an email to an advertiser when a campaign has ended
  def campaign_ends(advertiser, campaign)
    @advertiser = advertiser
    @campaign = campaign

    attachments.inline['logo.jpg'] = File.read(Rails.root.join('app/assets/images/logo.jpg'))
    attachments.inline['sellochico.jpg'] = File.read(Rails.root.join('app/assets/images/sellochico.jpg'))

    mail(to: advertiser.user.email, subject: "Notificaciones @ Borwin - Su campaña ha finalizado")
  end

  # Sends an email to admin alerting about a tweet expiration
  def expiration_alert_to_admin(tweet)
    @tweet = tweet

    mail(to: "sebastian@borwin.net", subject: "Tweet expira en 120 minutos - Its time to go social")
  end

  # Sends an email to advertiser alerting about a tweet expiration
  def expiration_alert_to_advertiser(tweet)
    @tweet = tweet

    attachments.inline['logo.jpg'] = File.read(Rails.root.join('app/assets/images/logo.jpg'))
    attachments.inline['sellochico.jpg'] = File.read(Rails.root.join('app/assets/images/sellochico.jpg'))

    mail(to: tweet.campaign.advertiser.user.email, subject: "Tweet expira en 120 minutos - Its time to go social")
  end

  # Sends an email to influencer alerting about a tweet expiration
  def expiration_alert_to_influencer(tweet)
    @tweet = tweet

    attachments.inline['logo.jpg'] = File.read(Rails.root.join('app/assets/images/logo.jpg'))
    attachments.inline['sellochico.jpg'] = File.read(Rails.root.join('app/assets/images/sellochico.jpg'))

    mail(to: tweet.influencer.user.email, subject: "Tweet expira en 120 minutos - Its time to go social")
  end

  # Sends an email to admin alerting about low credit
  def low_credit_warning_to_admin(user)
    @user = user
    @advertiser = user.advertiser

    mail(to: "sebastian@borwin.net", subject: "Anunciante con crédito debajo de $1000 - Its time to go social")
  end

  # Sends an email to advertiser alerting about low credit
  def low_credit_warning_to_advertiser(user)
    @user = user
    @advertiser = user.advertiser

    attachments.inline['logo.jpg'] = File.read(Rails.root.join('app/assets/images/logo.jpg'))
    attachments.inline['sellochico.jpg'] = File.read(Rails.root.join('app/assets/images/sellochico.jpg'))

    mail(to: user.email, subject: "Su crédito ha disminuido a $#{sprintf('%.02f', @user.balance)} - Its time to go social")
  end

  # Sends a cash out notice to the admin
  def cash_out_notice_to_admin(cash_out)
    @cash_out = cash_out

    if cash_out.user.role == 'influencer'
      subject = "La celebridad #{cash_out.user.full_name} ha solicitado un Cash Out por $#{cash_out.amount}"
    else
      subject = "La agencia #{cash_out.user.full_name} ha solicitado un Cash Out por $#{cash_out.amount}"
    end

    mail(to: "sebastian@borwin.net", subject: subject)
  end

  # Sends a cash out payment notice to the user
  def cash_out_paid(cash_out)
    @cash_out = cash_out

    attachments.inline['logo.jpg'] = File.read(Rails.root.join('app/assets/images/logo.jpg'))
    attachments.inline['sellochico.jpg'] = File.read(Rails.root.join('app/assets/images/sellochico.jpg'))

    mail(to: cash_out.user.email, subject: "Notificaciones @ Borwin -  Se ha realizado el pago de un Cash Out")
  end

end