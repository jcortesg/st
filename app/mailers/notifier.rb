class Notifier < ActionMailer::Base
  default from: "info@borwin.com.ar"

  # Site contact
  def contact(site_contact)
    @site_contact = site_contact

    mail(to: "info@borwin.com.ar", from: "contact@borwin.com.ar", subject: "Contacto @ Borwin - Its time to go social")
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
end