# encoding: utf-8
class SessionsController < ApplicationController
  # Ask the user to autentify his twitter account
  def new
    redirect_to '/auth/twitter'
  end

  # Creates the session though twitter oauth
  def create
    omniauth = request.env["omniauth.auth"]
    credentials = omniauth['credentials']

    if current_user && current_user.twitter_linked?
      # The user is logged in and he already linked his account in the past
      redirect_to root_path, :notice => "Tu cuenta ya esta linkeada a Twitter con el usuario #{current_user.twitter_screen_name}"
    elsif current_user && !current_user.twitter_linked?
      # The user is logged in and he's linked his account
      current_user.twitter_uid = omniauth['uid']
      current_user.twitter_screen_name = omniauth['info']['nickname']
      current_user.twitter_token = credentials['token']
      current_user.twitter_secret = credentials['secret']
      current_user.twitter_linked = true
      current_user.save!
      redirect_to home_path_for(current_user), :notice => "Has linkeado tu cuenta de Tweeter"
    else
      # Check if there is any user with that credential, and if there is, redirects the user
      if User.where(twitter_token: credentials['token'], twitter_secret: credentials['secret']).exists?
        @user = User.where(twitter_token: credentials['token'], twitter_secret: credentials['secret']).first
        # Login user and redirect
        sign_in(:user, @user)
        redirect_to home_path_for(@user)
      else
        # The credentials doesn't exist, create the account
        @user = User.new
        session['twitter_uid'] = omniauth['uid']
        session['twitter_screen_name'] = omniauth['info']['nickname']
        session['twitter_token'] = credentials['token']
        session['twitter_secret'] = credentials['secret']
        redirect_to new_influencer_registration_path
      end
    end
  end

  # Destroys the current session
  def destroy
    reset_session
    redirect_to root_url, :notice => 'Has cerrado tu sesión.'
  end

  # Callend when a failure happens with oauth
  def failure
    redirect_to root_url, :alert => "Error de autentificación: #{params[:message].humanize}"
  end
end
