# encoding: utf-8
class Notifier < ActionMailer::Base
  default from: "noreply@borwin.net"

  # Site contact
  def contact(site_contact)
    @site_contact = site_contact

    mail(to: "info@borwin.net", subject: "Contacto @ Borwin - Its time to go social")
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

    mail(to: 'info@borwin.com.ar', subject: "Notificaciones @ Borwin - Nuevo usuario registrado")
  end

  # Sends an email to the influencer to let him know that he has a new tweet proposal
  def tweet_creation(tweet)
    @tweet = tweet

    attachments.inline['logo.jpg'] = File.read(Rails.root.join('app/assets/images/logo.jpg'))
    attachments.inline['sellochico.jpg'] = File.read(Rails.root.join('app/assets/images/sellochico.jpg'))

    mail(to: tweet.influencer.user.email, subject: "Notificaciones @ Borwin - Recibiste una propuesta para un nuevo tweet")
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

    mail(to: tweet.campaign.advertiser.user.email, subject: "Notificaciones @ Borwin - Una propuesta de tweet que has relizado ha sido rechazada por una celebridad")
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
end