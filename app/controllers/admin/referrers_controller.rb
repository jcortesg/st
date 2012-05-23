# encoding: utf-8
class Admin::ReferrersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_admin

  # Show the list of referrals
  def index
    @search = User.where("referrer_id is not null").includes(:referrer).search(params[:search])
    @referrals = @search.page(params[:page])
  end

  # Shows a referral
  def show
    @referral = User.find(params[:id])
  end


  # Shows the form to create a new referrer
  def new
    @referralship = Referralship.new(referral_on: Date.today)
  end

  # Creates a new referrer
  def create
    @referralship = Referralship.new(params[:referralship])
    if @referralship.valid?
      # First get the referrer and the referral
      @referrer = User.find(@referralship.referrer)
      @referral = User.find(@referralship.referral)

      # Now create the referral relationship
      @referral.referrer = @referrer
      @referral.referrer_on = Date.today
      @referral.referrer_commission = @referral.role == 'advertiser' ? 10 : 5
      @referral.save!

      redirect_to admin_referrer_path(@referral)
    else
      flash[:error] = "Hubo un error al intentar crear la relación de referidos"
      render action: :new
    end
  end


  # Shows the form to edit a referral
  def edit
    @referral = User.find(params[:id])
  end

  # Process the update of a referral
  def update
    @referral = User.find(params[:id])
    if @referral.update_attributes(params[:user])
      flash[:notice] = "El referido ha sido actualizado con éxito"
      redirect_to admin_referrer_path(@referral)
    else
      flash[:error] = "Hubo un error al intentar actualizar el referido"
      render action: :edit
    end
  end

  # Deletes a referrer
  def destroy
    @referral = User.find(params[:id])
    @referral.referrer_id = nil
    @referral.referrer_on = nil
    @referrer.referrer_commission = nil
    @referrer.save
    flash[:notice] = "La relación de refrido fue eliminada"
    redirect_to action: :index
  end
end
