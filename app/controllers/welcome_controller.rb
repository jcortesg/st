class WelcomeController < ApplicationController
  skip_before_filter :authenticate_user!
  layout :sign
  
  def index
    #redirect_to "http://www.borwin.com.ar"
  end

  def advertisers
  end
  
  def influencers
  end
  
  def analytics
  end
  
  def about
  end
  
  def contact
  end   
  
  def contact_post
    Notifier.contact(params[:message]).deliver
    
    redirect_to root_path, notice: "Tu mensaje fue recibido. Nos pondremos en contacto a la brevedad"
  end  
  
  def terms
  end 
  
  private
  def sign
    action_name == :terms ? "sign" : "application"
  end
end