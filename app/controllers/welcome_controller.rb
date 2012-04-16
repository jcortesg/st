class WelcomeController < ApplicationController
  # Website main page
  def index
    #redirect_to "http://www.borwin.com.ar"
  end

  # Plataforma
  def about
    render :action => 'demo_page'
  end

  # Anunciantes
  def advertisers
    render :action => 'demo_page'
  end

  # Celebridades
  def influencers
    render :action => 'demo_page'
  end

  # Analytics
  def analytics
    render :action => 'demo_page'
  end

  # Shows the contact form
  def contact
    @site_contact = SiteContact.new
  end   

  # Process the ocntact form
  def process_contact
    @site_contact = SiteContact.new(params[:contact])

    if @site_contact.save
      redirect_to root_path, :notice => "Tu mensaje fue recibido. Nos pondremos en contacto a la brevedad."
    else
      render :action => :contact
    end
  end

  # Terms (not used?)
  def terms
    render :action => 'demo_page'
  end 

end