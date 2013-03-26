# encoding: utf-8
class Admin::UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_admin
  layout "admin"

  # Shows the list of users that requires authorization to be able to access the website
  def index
    search_params = {"approved_equals" => "false", "meta_sort" => "created_at.desc"}.merge(params[:search] || {})
    @search = User.search(search_params)
    @users = @search.page(params[:page])
  end

  # Enables a user account
  def approve
    @user = User.find(params[:id])
    @user.approve unless @user.approved

    flash[:notice] = "El usuario ha sido activado"
    redirect_to [:admin, :users]
  end

  # Disable a user account
  def disapprove
    @user = User.find(params[:id])
    @user.update_attribute(:approved, false) if @user.approved

    redirect_to [:admin, :users]
  end

  # Destroys a user
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    flash.now[:notice] = "El usuario ha sido eliminado"

    redirect_to [:admin, :users]
  end

  # Shows the form to recategorize a user
  def recategorize
    @user = User.find(params[:id])
  end

  # Recategorizes a celebrity
  def do_recategorize
    @user = User.find(params[:id])

    if @user.role == params[:user][:role]
      if params[:user][:role] == 'affiliate'
        flash.now[:error] = "El usuario ya es una agencia"
      elsif params[:user][:role] == 'advertiser'
        flash.now[:error] = "El usuario ya es un anunciante"
      end
      render action: :recategorize
    elsif params[:user][:role] == 'advertiser'
      # Convert an affiliate into an advertiser
      User.transaction do
        affiliate = @user.affiliate
        advertiser = Advertiser.new
        advertiser.user = @user
        advertiser.company = affiliate.company
        advertiser.first_name = affiliate.first_name
        advertiser.last_name = affiliate.last_name
        advertiser.address = affiliate.address
        advertiser.city = affiliate.city
        advertiser.state = affiliate.state
        advertiser.country = affiliate.country
        advertiser.zip_code = affiliate.zip_code
        advertiser.phone = affiliate.phone
        advertiser.phone = rand(10) if advertiser.phone.blank?
        advertiser.user = @user
        advertiser.save!
        @user.role = 'advertiser'
        @user.save!
        affiliate.destroy

        flash[:success] = "El usuario ha sido recategorizado"
        redirect_to [:admin, :users]
      end
    elsif params[:user][:role] == 'affiliate'
      # Convert an advertiser into an affiliate
      User.transaction do
        advertiser = @user.advertiser
        affiliate = Affiliate.new
        affiliate.user = @user
        affiliate.company = advertiser.company
        affiliate.first_name = advertiser.first_name
        affiliate.last_name = advertiser.last_name
        affiliate.address = advertiser.address
        affiliate.city = advertiser.city
        affiliate.state = advertiser.state
        affiliate.country = advertiser.country
        affiliate.zip_code = advertiser.zip_code
        affiliate.phone = advertiser.phone
        affiliate.phone = rand(10) if advertiser.phone.blank?
        affiliate.user = @user
        affiliate.save!
        @user.role = 'affiliate'
        @user.save!
        advertiser.destroy

        flash[:success] = "El usuario ha sido recategorizado"
        redirect_to [:admin, :users]
      end
    else
      flash.now[:error] = "Rol no reconocido"
      render action: :recategorize
    end
  end

end
