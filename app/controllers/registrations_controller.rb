# encoding: utf-8
class RegistrationsController < Devise::RegistrationsController
  before_filter :authenticate_user!, :except => [:new, :new_affiliate, :new_influencer, :create]
  layout 'application'

  # Shows the form to create a new advertiser
  def new
    resource = build_resource
    resource.role = 'advertiser'
    resource.build_advertiser
    @referrer = User.where(:id => session[:referrer_id]).first if session[:referrer_id]
    respond_with resource
  end

  # Shows the form to create a new affiliate
  def new_affiliate
    resource = build_resource
    resource.role = 'affiliate'
    resource.build_affiliate
    respond_with resource
  end

  # Shows the twitter button to link the user account
  def new_influencer
  end

  # Creates the user
  def create
    @user = User.new(params[:user])
    @user.role = params[:user_role] == 'advertiser' ? 'advertiser' : 'affiliate'
    if @user.save
      # Update the commission if the created user is an advertiser and there is a session for the invitation
      if session[:referrer_id] && @user.role == 'advertiser'
        @user.update_attribute(:referrer_commission, 10)
      end
      if session[:referrer_id] && @user.role == 'influencer'
        @user.update_attribute(:referrer_commission, 5)
      end
      session[:referrer_id] = nil

      set_flash_message :notice, :signed_up if is_navigational_format?
      sign_in('user', @user)
      respond_with @user, :location => after_sign_up_path_for(@user)
    else
      @referrer = User.where(:id => session[:referrer_id]).first if session[:referrer_id]
      clean_up_passwords @user
      if @user.advertiser?
        #@user.advertiser || @user.build_advertiser
        render action: :new
      else
        #@user.affiliate || @user.build_affiliate
        render action: :new_affiliate
      end
    end
  end


end