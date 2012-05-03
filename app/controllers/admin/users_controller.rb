class Admin::UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_admin

  def index
    @users = User.all_except_admin
  end

  def approve
    @user = User.find(params[:id])
    @user.approve unless @user.approved

    flash[:notice] = "El usuario ha sido activado"
    redirect_to [:admin, :users]
  end

  def disapprove
    @user = User.find(params[:id])
    @user.update_attribute(:approved, false) if @user.approved

    redirect_to [:admin, :users]
  end

end
