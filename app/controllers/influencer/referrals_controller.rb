# encoding: utf-8
class Influencer::ReferralsController < ApplicationController
  before_filter :authenticate_user!, :require_advertiser, :check_twitter_linked

  # Shows the information for getting referrals and the money so far
  def index
    @user = current_user
    @referrals = User.where(referrer_id: current_user.id)
  end

  # Shows the list of referrals for the user
  def list
    @user = current_user
    @referrals = User.where(referrer_id: current_user.id)
  end

  # Update the referral options for the current_user
  def update_options
    @user = current_user
    if current_user.update_attributes(params[:user])
      flash[:success] = "Sus preferencias han sido actualizadas"
    else
      flash[:error] = "Hubo un error al actualizar sus preferencias"
    end
    redirect_to action: :index
  end
end
