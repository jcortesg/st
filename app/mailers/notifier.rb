class Notifier < ActionMailer::Base
  default from: "info@borwin.com.ar"

  def contact(data)    
    @from = data[:from]
    @email = data[:email] 
    @title = data[:title] 
    @message = data[:message] 

    mail(:to => "info@borwin.com.ar", :from => "contact@borwin.com.ar", :subject => "Contacto @ Borwin - Its time to go social")
  end  
  
  def approve(user)
    @user = user
    attachments.inline['logo.jpg'] = File.read(Rails.root.join('app/assets/images/logo.jpg'))
    attachments.inline['sellochico.jpg'] = File.read(Rails.root.join('app/assets/images/sellochico.jpg'))
    
    mail(:to => @user.email, :subject => "Cuenta Activada @ Borwin - Its time to go social")
  end
  
  def disapprove(user)
    @user = user
    attachments.inline['logo.jpg'] = File.read('app/assets/images/logo.jpg')
    
    mail(:to => user.email, :subject => "Cuenta Desactivada @ Borwin - Its time to go social")
  end
end