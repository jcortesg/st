class RegistrationsController < Devise::RegistrationsController
  before_filter :authenticate_user!, :except => [:new, :new_affiliate, :new_influencer, :create]
  layout 'application'

  def new
    resource = build_resource
    resource.role = 'advertiser'
    resource.build_advertiser
    respond_with resource
  end

  def new_affiliate
    resource = build_resource
    resource.role = 'affiliate'
    resource.build_affiliate
    render :action => :new
  end

  def new_influencer
  end


end