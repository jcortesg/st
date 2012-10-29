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
    @site_advertiser_contact = SiteAdvertiserContact.new
  end

  # Anunciantes - Porcess Contact Form
  def process_advertiser_contact
    @site_advertiser_contact = SiteAdvertiserContact.new(params[:site_advertiser_contact])

    if @site_advertiser_contact.save
      flash[:success] = "Tu mensaje fue recibido. Nos pondremos en contacto a la brevedad."
      redirect_to root_path
    else
      render :action => :contact
    end
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
  # http://localhost:3000/I123456
  def invitation
    if User.where(invitation_code: params[:invitation_code]).exists?
      @referrer = User.where(invitation_code: params[:invitation_code]).first
      session[:referrer_id] = @referrer.id
      #redirect_to influencer_devise_registration_path
    else
      flash[:error] = "El código de invitación no es válido"
      redirect_to root_path
    end
  end

  # Tweet link redirection
  # http://localhost:3000/L1234
  def tweet_link_redirection
    if Tweet.where(link_code: params[:link_code]).exists?
      tweet = Tweet.where(link_code: params[:link_code]).first
      Click.create(tweet: tweet, remote_ip: request.env['REMOTE_ADDR'], remote_agent: request.env['HTTP_USER_AGENT'])
      redirect_to tweet.link_url
    else
      flash[:error] = "El código de tweet no existe"
      redirect_to root_url
    end
  end

  # Tweet link redirection
  # http://localhost:3000/P1234
  def tweet_image_redirection
    if Picture.where(picture_code: params[:picture_code]).exists?
      image = Picture.where(picture_code: params[:picture_code]).first
      Click.create(tweet: image.tweet, remote_ip: request.env['REMOTE_ADDR'], remote_agent: request.env['HTTP_USER_AGENT'])
      redirect_to '/pictures/'+image.id.to_s
    else
      flash[:error] = "El código de imagen no existe"
      redirect_to root_url
    end
  end

end