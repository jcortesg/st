# encoding: utf-8
class RegistrationsController < Devise::RegistrationsController
  before_filter :authenticate_user!, :except => [:new, :new_affiliate, :new_influencer, :create]
  layout 'application'

  # Shows the form to create a new advertiser
  def new
    resource = build_resource
    resource.role = 'advertiser'
    resource.build_advertiser
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

  def create
    @user = User.new(params[:user])
    @user.role = params[:user_role] == 'advertiser' ? 'advertiser' : 'affiliate'
    if @user.save
      set_flash_message :notice, :signed_up if is_navigational_format?
      sign_in('user', @user)
      respond_with @user, :location => after_sign_up_path_for(@user)
    else
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