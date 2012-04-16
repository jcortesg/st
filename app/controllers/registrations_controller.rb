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
  end

  # Shows the twitter button to link the user account
  def new_influencer
  end


end