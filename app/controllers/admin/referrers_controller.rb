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

  # Show the form to create a new referrer
  def new
    @user = User.new
    @user.build_referrer
  end

  # Process the creation of a new referrer
  def create
    @user = User.new(params[:user])
    @user.role = 'referrer'
    # Account approved
    @user.approved = true

    if @user.save
      @referrer = @user.referrer
      flash[:notice] = "El anunciante #{@referrer.full_name} fue creado con éxito"
      redirect_to [:admin, @referrer]
    else
      flash[:error] = "Hubo un error al intentar crear el anunciante"
      render action: :new
    end
  end


  # Shows the form to edit a referrer
  def edit
    @referrer = Referrer.find(params[:id])
    @user = @referrer.user
  end

  # Process the update of a referrer
  def update
    @referrer = Referrer.find(params[:id])
    @user = @referrer.user
    if @user.update_attributes(params[:referrer])
      flash[:notice] = "El anunciante #{@referrer.full_name} fue actualizado con éxito"
      redirect_to [:admin, @referrer]
    else
      flash[:error] = "Hubo un error al intentar actualizar el anuncianate"
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
