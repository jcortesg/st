class Devise::Mailer < ::ActionMailer::Base
  include Devise::Mailers::Helpers

  def confirmation_instructions(record)    
    #attachments.inline['logo.jpg'] = File.read(Rails.root.join('app/assets/images/logo.jpg'))
    devise_mail(record, :confirmation_instructions)
    #devise_mail(:to => 'info@borwin.com.ar', :confirmation_instructions)
  end

  def reset_password_instructions(record)
    devise_mail(record, :reset_password_instructions)
  end
  
  def unlock_instructions(record)
    devise_mail(record, :unlock_instructions)
  end
end