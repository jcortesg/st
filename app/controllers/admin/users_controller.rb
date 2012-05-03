class Admin::UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_admin

  # Shows the list of users that requires authorization to be able to access the website
  def index
    @search = User.search(params[:search])
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

end
