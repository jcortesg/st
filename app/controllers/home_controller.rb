class HomeController < ApplicationController
  include ApplicationHelper

  # Website main page
  def index
  end

  # Anunciantes - Vision General
  def advertisers_about
  end

  # Anunciantes - Contacto
  def advertisers_contact
    contact
    render action: 'contact'
  end

  # Celebridades - Vision General
  def influencers_about
  end

  # Celebridades - Contacto
  def influencers_contact
    contact
    render action: 'contact'
  end

  # Plataforma - Tweet Go
  def tweet_go
    render action: 'demo_page'
  end

  # Nosotros - La Empresa
  def about_us
    render action: 'demo_page'
  end

  # Nosotros - Prensa
  def press
    render action: 'demo_page'
  end

  # Nosotros - Trabaja con Nosotros
  def work_with_us
    render action: 'demo_page'
  end

  # Nosotros - Contactenos
  def contact
    @site_contact = SiteContact.new
  end

  # Process the contact form
  def process_contact
    @site_contact = SiteContact.new(params[:contact])

    if @site_contact.save
      redirect_to root_path, :notice => "Tu mensaje fue recibido. Nos pondremos en contacto a la brevedad."
    else
      render :action => :contact
    end
  end

  # Terms
  def terms
    render :action => 'demo_page'
  end
end