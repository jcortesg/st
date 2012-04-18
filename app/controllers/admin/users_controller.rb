class Admin::UsersController < ApplicationController
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
