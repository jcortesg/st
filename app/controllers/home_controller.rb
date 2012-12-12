# encoding: utf-8
require 'mercadopago.rb'

class HomeController < ApplicationController
  include ApplicationHelper

  # Website main page
  def index
    if true
      if !cookies[:country].nil? && cookies[:redirected].nil?
        case cookies[:country]
          when 'AR'
            redirect_to 'http://borwin.net'
          when 'MX'
            redirect_to 'http://mexico.borwin.net'
          when 'CO'
            redirect_to 'http://colombia.borwin.net'
          else
            #redirect_to 'http://borwin.net'
        end
      elsif !cookies[:redirected].nil?
          # ?
      else
        ip = request.remote_ip
        country = Geocoder.search(ip)[0].data['country_name'].to_s
        case country
          when 'Argentina'
            redirect_to country_redirector_path({:code => 'AR'})
          when 'Mexico'
            redirect_to country_redirector_path({:code => 'MX'})
          when 'Colombia'
            redirect_to country_redirector_path({:code => 'CO'})
          else
            redirect_to country_redirector_path({:code => 'NO'})
        end
      end
    end
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

  # Nosotros - Presentacion
  def presentacion
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

  def country_redirector
    country = params[:code]
    cookies[:country] = {
        :value => country,
        :expires => 1.month.from_now,
        :domain => :all
    }
    case country
      when 'AR'
        cookies[:redirected] = true
        @redirector = 'http://borwin.net'
      when 'MX'
        cookies[:redirected] = true
        @redirector = 'http://mexico.borwin.net'
      when 'CO'
        cookies[:redirected] = true
        @redirector = 'http://colombia.borwin.net'
      else
        cookies[:redirected] = true
        @redirector = 'http://borwin.net'
      end
  end

  # Invitation registration
  # http://localhost:3000/I123456
  def invitation
    length = params[:invitation_code].length
    if length > 6
      case params[:invitation_code][0]
        when 'A'
          if APP_CONFIG['app_country'] != 'AR'
            redirect_to 'http://borwin.net/I'+params[:invitation_code].to_s
            return
          end
        when 'C'
          if APP_CONFIG['app_country'] != 'CO'
            redirect_to 'http://colombia.borwin.net/I'+params[:invitation_code].to_s
            return
          end
        when 'M'
          if APP_CONFIG['app_country'] != 'MX'
            redirect_to 'http://mexico.borwin.net/I'+params[:invitation_code].to_s
            return
          end
      end
    end
    invitation_code = params[:invitation_code][0..length]

    if User.where(invitation_code: invitation_code).exists?
      @referrer = User.where(invitation_code: invitation_code).first
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
    length = params[:link_code].length
    if length > 4
      case params[:link_code][0]
        when 'A'
          if APP_CONFIG['app_country'] != 'AR'
            redirect_to 'http://borwin.net/P'+params[:link_code].to_s
            return
          end
        when 'C'
          if APP_CONFIG['app_country'] != 'CO'
            redirect_to 'http://colombia.borwin.net/P'+params[:link_code].to_s
            return
          end
        when 'M'
          if APP_CONFIG['app_country'] != 'MX'
            redirect_to 'http://mexico.borwin.net/P'+params[:link_code].to_s
            return
          end
      end
    end
    link_code = params[:link_code][0..length]

    if Tweet.where(link_code: link_code).exists?
      tweet = Tweet.where(link_code: link_code).first
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
    length = params[:picture_code].length
    if length > 4
      case params[:picture_code][0]
        when 'A'
          if APP_CONFIG['app_country'] != 'AR'
            redirect_to 'http://borwin.net/P'+params[:picture_code].to_s
            return
          end
        when 'C'
          if APP_CONFIG['app_country'] != 'CO'
            redirect_to 'http://colombia.borwin.net/P'+params[:picture_code].to_s
            return
          end
        when 'M'
          if APP_CONFIG['app_country'] != 'MX'
            redirect_to 'http://mexico.borwin.net/P'+params[:picture_code].to_s
            return
          end
      end
    end
    picture_code = params[:picture_code][0..length]

    if Picture.where(picture_code: picture_code).exists?
      image = Picture.where(picture_code: picture_code).first
      Click.create(tweet: image.tweet, remote_ip: request.env['REMOTE_ADDR'], remote_agent: request.env['HTTP_USER_AGENT'])
      redirect_to '/pictures/'+image.id.to_s
    else
      flash[:error] = "El código de imagen no existe"
      redirect_to root_url
    end
  end

  # Endpoint to receive notifications from mercadopago
  def ipn_endpoint
    topic = params[:payment]
    payment_id = params[:id]

    mp_client = MercadoPago.new(APP_CONFIG['mercadopago_client_id'], APP_CONFIG['mercadopago_client_secret'])

    notification = mp_client.get_payment_info(payment_id)
    puts "MP response: " + notification.to_s

    parsed_json = ActiveSupport::JSON.decode(notification)
    payment = Payment.where('external_reference == ?', parsed_json['collection']['external_reference']).first
    payment.update_attribute('status', parsed_json['collection']['status'])
  end

end