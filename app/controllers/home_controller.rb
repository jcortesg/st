# encoding: utf-8
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
  end

  # Anunciantes - Presentacion
  def advertisers_presentation
  end

  # Celebridades - Vision General
  def influencers_about
  end

  # Celebridades - Contacto
  def influencers_contact
    contact
  end

  # Celebridades - Presentacion
  def influencers_presentation
  end

  # Plataforma - Tweet Go
  def tweet_go
  end

  # Nosotros - La Empresa
  def about_us
  end

  # Nosotros - Prensa
  def press
  end

  # Nosotros - Trabaja con Nosotros
  def work_with_us
  end

  # Nosotros - Contactenos
  def contact
    @site_contact = SiteContact.new
  end

  # Process the contact form
  def process_contact
    @site_contact = SiteContact.new(params[:site_contact])

    if @site_contact.save
      flash[:success] = "Tu mensaje fue recibido. Nos pondremos en contacto a la brevedad."
      redirect_to root_path
    else
      render :action => :contact
    end
  end

  # Terms
  def terms
  end

  # Privacy
  def privacy
  end

  # Invitation registration
  # http://localhost:3000/IRI55AU
  def invitation
    if User.where(invitation_code: params[:invitation_code]).exists?
      user = User.where(invitation_code: params[:invitation_code]).first
      session[:referrer_id] = user.id
      redirect_to influencer_devise_registration_path
    else
      flash[:error] = "El código de invitación no es válido"
      redirect_to root_path
    end
  end
end